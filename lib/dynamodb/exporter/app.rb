require 'thor'
require 'dynamodb/exporter/export'

module Dynamodb
  module Exporter
    class App < Thor

      include Thor::Actions
      package_name 'Dynamodb Exporter'

      desc 'export [table_name]', 'Exports the contents of the given table to a json dump'
      method_option :read_ratio, :type => :numeric, :desc => 'The percentage of read capacity to use (out of 100)', :default => '10'
      method_option :region, :type => :string, :desc => 'The region to use, default will be picked up from ENV variables'
      method_option :limit, :type => :numeric, :desc => 'How many results to get per request', :default => 20
      method_option :output, :type => :string, :desc => 'Where the contents should be output', :default => './output.json'
      def export(table_name)
        say 'Begining export...', :white

        contents = Export.new(table_name, options[:read_ratio]).run!
        File.open(options[:output]).write(contents)

        say 'Export complete', :green
      end

    end
  end
end
