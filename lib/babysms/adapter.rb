module BabySMS
  class Adapter
    attr_reader :from
    attr_reader :client

    def initialize(from:)
      @from = Phony.normalize(from)
    end

    protected
    def client=(value)
      @client = value
    end
  end
end
