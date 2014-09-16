require 'aws-sdk'
require 'yaml'

module Dynamodb
  module Exporter
    class Export

      attr_reader :table_name, :contents, :rate

      def initialize(table_name, rate)
        @table_name = table_name
        @rate       = rate
        @ddb        = ::AWS::DynamoDB::Client.new(:api_version => '2011-12-05')

        @contents   = []
        @start_key  = true
      end

      def run!
        while @start_key do
          scan.tap do |s|
            @contents << contents_from(s)
            @start_key = last_key_from s
          end

          sleep 1
        end

        @contents
      end

      def write
        File.open('out.yaml', 'w') {|f| f.write @contents.to_yaml }
      end

      protected

      def read_capacity
        table_meta["Table"]["ProvisionedThroughput"]["ReadCapacityUnits"]
      end

      def table_meta
        @table_meta ||= @ddb.describe_table( :table_name => table_name )
      end

      def scan
        @ddb.scan options_with(limit, @start_key)
      end

      def last_key_from(scan)
        scan["LastEvaluatedKey"]
      end

      def contents_from(scan)
        scan["Items"]
      end

      def options_with(limit, start_key = nil)
        {
          :table_name => table_name,
          :limit => rate,
        }.tap do |o|
          o[:exclusive_start_key] = start_key if start_key.is_a? Hash
        end
      end

    end
  end
end
