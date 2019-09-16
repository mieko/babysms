require 'rack'
require 'active_support'
require 'active_support/core_ext/module/attribute_accessors'

module BabySMS
  module Microweb
    module ClassMethods
      def h(text)
        ::Rack::Utils.escape_html(text)
      end

      cattr_accessor :handlers, default: {}

      [:get, :post, :put, :delete].each do |request_method|
        define_method(request_method) do |path, &block|
          handlers["#{request_method} #{path}"] = lambda(&block)
        end
      end
    end

    def self.included(cls)
      cls.extend(ClassMethods)
    end

    def call(env)
      request = Rack::Request.new(env)
      response = Rack::Response.new([], 500, { "Content-Type" => "application/json" })

      key = "#{request.request_method.downcase} #{request.path}"

      if (handler = self.class.handlers[key])
        result = handler.call(request, response, env)
        response.body = result unless result.nil?
      else
        response.status = 404
        response.body = "not found"
      end

      [response.status, response.headers, StringIO.new(response.body)]
    end
  end
end
