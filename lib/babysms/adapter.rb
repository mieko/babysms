module BabySMS
  class Adapter
    attr_reader :from
    attr_reader :client

    def initialize(from:)
      @from = Phony.normalize(from)
    end

    def self.for_number(number)
      number = Phony.normalize(number)
      BabySMS.adapters.find { |adapter| adapter.from == number }
    end

    def self.adapter_name
      bare_name = name.split('::').last
      bare_name.gsub(/Adapter\z/, '').downcase
    end

    def adapter_id
      "#{from}@#{self.class.adapter_name}"
    end

    protected

    attr_writer :client
  end
end
