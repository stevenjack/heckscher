module Hecksher
  class Reader
    attr_reader :filename, :limit

    def initialize(filename, limit)
      @filename = filename
      @limit    = limit
    end

    def perform(&block)
      File.open(filename, 'r') { |h| read(h, block); nil }
    end

    protected

    def read(h, block)
      [].tap do |threads|
        while(!h.eof?) do
          process(h) { |o| threads << Thread.new { block.call(o) } }
        end
      end.each(&:join)
    end

    def process(h)
      yield (1..limit).to_a.map! { h.readline } unless h.eof?
    end
  end
end

