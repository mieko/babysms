module BabySMS
  class Adapter
    attr_reader :from
    attr_reader :client

    def initialize(from:)
      @from = Phony.normalize(from)
    end

    def self.for_number(number, pool: BabySMS.adapters)
      number = Phony.normalize(number)
      pool.find { |adapter| adapter.from == number }
    end

    def self.for_adapter_id(adapter_id, pool: BabySMS.adapters)
      pool.find { |adapter| adapter.adapter_id == adapter_id }
    end

    def self.adapter_name
      bare_name = name.split('::').last
      bare_name.gsub(/Adapter\z/, '').downcase
    end

    def adapter_name
      self.class.adapter_name
    end

    def adapter_id
      "#{from}@#{adapter_name}"
    end

    def web_hook_class
      self.class.const_get(:WebHook)
    end

    def web_hook?
      !!web_hook_class
    end

    def web_hook
      unless instance_variable_defined?(:@web_hook)
        @web_hook = if (cls = web_hook_class)
          cls.new(self)
        end
      end

      @web_hook
    end

    protected

    attr_writer :client
  end
end
