require 'thread/pool'

module Heckscher
  class Reader
    attr_reader :filename, :limit

    def initialize(filename, limit)
      @filename    = filename
      @limit       = limit
      @thread_pool = Thread.pool(8)
    end

    def perform(&block)
      File.open(filename, 'r') { |h| read(h, block); nil }
    end

    def lines
      @lines ||= IO.foreach(filename).reduce(0) { |c| c + 1 }
    end

    protected

    def read(h, block)
      while(!h.eof?) do
        process(h) { |o| @thread_pool.process { block.call(o) } }
      end
    end

    def process(h)
      yield (1..limit).to_a.map! { h.readline.chomp } unless h.eof?
    end
  end
end
