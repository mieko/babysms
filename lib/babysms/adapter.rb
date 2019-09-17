module BabySMS
  class Adapter
    attr_reader :from
    attr_reader :client

    def initialize(from:)
      @from = Phony.normalize(from)
    end

    # Locates an adapter instance associated with a phone number
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

    # e.g., "twilio"
    def adapter_name
      self.class.adapter_name
    end

    # e.g., "15555555555@twilio"
    def adapter_id
      "#{from}@#{adapter_name}"
    end

    # if the adapter supports web hooks, it'll have a nested class
    # called "WebHook".  This returns the class
    def web_hook_class
      self.class.const_get(:WebHook)
    end

    def web_hook?
      !!web_hook_class
    end

    # Returns an instance of the web hook handler, if it exists
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
