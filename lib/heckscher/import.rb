require 'aws-sdk'

module Heckscher
  class Import

    attr_reader :table_name, :rate, :items_put

    def initialize(table_name, rate, io_stream)
      @table_name = table_name
      @rate       = rate
      @io_stream  = io_stream
      @items_put  = 0
    end

    def run!
    end

    def percentage_done
      ((items_put.to_f / item_count.to_f) * 100).round
    end

  end
end
