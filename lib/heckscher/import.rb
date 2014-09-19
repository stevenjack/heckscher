require 'aws-sdk'
require 'json'

module Heckscher
  class Import

    attr_reader :filename, :table_name, :rate, :items_put

    def initialize(reader, table_name, rate)
      @reader     = reader
      @table_name = table_name
      @rate       = rate
      @items_put  = 0
      @ddb        = ::AWS::DynamoDB::Client.new(:api_version => '2012-08-10')
    end

    def run!

      @reader.perform do |items|
        puts "Doing put action #{items}\n\n"
        #@ddb.batch_write payload(items)
        @items_put = @items_put + items.length
      end

    end

    def percentage_done
      ((items_put.to_f / @reader.lines.to_f) * 100).round
    end

    protected

    def payload(items)
      {
        :request_items => {
        :put_request => JSON::parse(items)
      },
        :return_consumed_capacity => 'TOTAL'
      }
    end

  end
end
