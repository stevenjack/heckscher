require 'thor'
require 'dynamodb/exporter/export'
require 'json'

module Dynamodb
  module Exporter
    class App < Thor

      include Thor::Actions
      package_name 'Dynamodb Exporter'

      desc 'export [table_name]', 'Exports the contents of the given table to a json dump'
      method_option :read_ratio, :type => :numeric, :desc => 'The percentage of read capacity to use (out of 100)', :default => '10'
      method_option :limit, :type => :numeric, :desc => 'How many results to get per request', :default => 20
      method_option :output, :type => :string, :desc => 'Where the contents should be output', :default => './output.json'
      def export(table_name)
        say 'Begining export...', :white

        handle = File.open(options[:output], 'w')
        export = Export.new(table_name, options[:limit], handle)

        say "\nApprox items in table: #{export.item_count}\n", :green
        t = export.run!

        begin
          say "~#{export.percentage_done}% (#{export.items_read}, consumed capacity: #{(export.consumed_capacity * 8)})\e[1A"
        end until export.percentage_done >= 100


        t.join
        handle.close

        say "\n\nExport complete", :green
      end

    end
  end
end
