module BabySMS
  class WebHook
    attr_reader :adapter

    def initialize(adapter)
      @adapter = adapter
    end

    # This is where the webhook handler is mounted relative to the Rack application
    def mount_point
      "/#{adapter.adapter_id}"
    end

    # This is the public URL of the webhook
    def end_point
      # Remove optional trailing '/' in configuration
      root = BabySMS.web_hook_root.gsub(/\/\z/, '')
      root + mount_point
    end
  end
end
