module Dynamodb
  module Exporter
    class Export

      attr_reader :table_name, :contents, :limit

      def initialize(table_name, limit)
        @table_name = table_name
        @limit      = limit
        @ddb        = AWS::DynamoDB::Client.new(:api_version => '2011-12-05')

        @contents   = []
        @start_key  = nil
      end

      def run
        while @start_key do
          scan.tap do |s|
            @contents.push contents_from(s)
            @start_key = last_key_from s
          end
        end
      end

      protected

      def scan
        @ddb.scan options_with(limit, start_key)
      end

      def last_key_from(scan)
        # do work
        last_evaluated_key
      end

      def contents_from(scan)
        # do work
        contents
      end

      def options_with(limit, exclusive_start_key || 0)
        # setup options
        {
          :foo => 'bar'
        }
      end

    end
  end
end
