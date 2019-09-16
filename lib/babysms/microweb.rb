require 'rack'
require 'active_support'
require 'active_support/core_ext/module/attribute_accessors'

module BabySMS
  module Microweb
    Request = Struct.new(:http_method, :path, :post_data, keyword_init: true)
    Response = Struct.new(:status, :content_type, keyword_init: true)


    module ClassMethods
      def h(text)
        ::Rack::Utils.escape_html(text)
      end

      cattr_accessor :handlers, default: {}

      [:get, :post, :put, :delete].each do |http_method|
        define_method(http_method) do |path, &block|
          self.handlers["#{http_method} #{path}"] = lambda(&block)
        end
      end
    end

    def self.included(cls)
      cls.extend(ClassMethods)
    end

    def call(env)
      request = Request.new(http_method: env['REQUEST_METHOD'].downcase.to_sym,
                            path: env['REQUEST_URI'])
      response = Response.new(status: 200,
                              content_type: "application/json")

      key = "#{request.http_method} #{request.path}"

      body = if (handler = self.class.handlers[key])
        handler.call(request, response)
      else
        response.status = 404
        "not found"
      end

      [ response.status,
        { "Content-Type" => response.content_type },
        StringIO.new(body)
      ]
    end
  end
end
