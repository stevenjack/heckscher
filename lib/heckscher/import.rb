require 'aws-sdk'

module Heckscher
  class Import

    attr_reader :filename, :table_name, :rate, :items_put

    def initialize(reader, table_name, rate)
      @reader     = reader
      @table_name = table_name
      @rate       = rate
      @items_put  = 0
    end

    def run!
    end

    def percentage_done
      ((items_put.to_f / item_count.to_f) * 100).round
    end

  end
end
