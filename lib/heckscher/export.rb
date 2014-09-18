require 'aws-sdk'
require 'yaml'

module Heckscher
  class Export

    attr_reader :table_name, :rate, :items_read, :consumed_capacity

    def initialize(table_name, rate, io_stream)
      @table_name      = table_name
      @rate            = rate
      @ddb             = ::AWS::DynamoDB::Client.new(:api_version => '2012-08-10')

      @io_stream       = io_stream
      @items_read      = 0
      @mutex           = Mutex.new
      @threads_complete = 0
      @consumed_capacity = 0
    end

    def run!
      Thread.new do
        total_segments = 8
        threads = []

        total_segments.times do |segment|
          threads << Thread.new do
            t[:start_key] = true

            while t[:start_key] do
              @ddb.scan(options_with(t[:start_key], total_segments, segment)).tap do |s|
                @mutex.synchronize do
                  @consumed_capacity = s[:consumed_capacity][:capacity_units]
                  @io_stream.tap do |io|
                    s[:member].each { |m| io << "#{JSON::generate(m)}\n" }
                  end.flush
                  @items_read = items_read + s[:member].length
                end
                t[:start_key] = s[:last_evaluated_key]
              end
            end
          end
        end

        threads.each { |t| t.join }
      end
    end

    def percentage_done
      ((items_read.to_f / item_count.to_f) * 100).round
    end

    def item_count
      @item_count ||= @ddb.describe_table({:table_name => @table_name})[:table][:item_count]
    end

    protected

    def t
      Thread.current
    end

    def options_with(start_key = nil, total_segments = 1, segment = 0)
      {
        :total_segments           => total_segments,
        :table_name               => table_name,
        :limit                    => rate.to_i,
        :segment                  => segment,
        :return_consumed_capacity => 'TOTAL'
      }.tap do |o|
        o[:exclusive_start_key] = start_key if start_key.is_a? Hash
      end
    end

  end
end
