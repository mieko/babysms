require 'babysms'
require 'json'
require 'sinatra/base'
require 'babysms/report'

module BabySMS
  class WebApplication < Sinatra::Base
    helpers do
      def h(text)
        Rack::Utils.escape_html(text)
      end
    end

    post '/:adapter_id' do
      adapter = BabySMS::Adapter.for_adapter_id(params['adapter_id'])
      if adapter&.web_hook?
        report = BabySMS::Report.new(adapter)
        adapter.web_hook.process(app: self, report: report)
      else
        status 404
        content_type "text/plain"
        "not found"
      end
    end

    get '/' do
      index_html = <<~"HTML".freeze
        <!DOCTYPE html>
          <head>
            <title>BabySMS #{h BabySMS::VERSION} Endpoint</title>
            <style>
              html { margin: 4em; font-family: monospace; }
              body { max-width: 45em; }
              h2 { margin-top: 2em; }
            </style>
          </head>
          <body>
            <h1>BabySMS #{h BabySMS::VERSION} Feedback Endpoint</h1>
              <p>BabySMS is reachable here to allow SMS providers to contact your web hooks.</p>
              <p>This application should be off-limits to world at large, either via password
              protection, host-based authorization, or both.

              <p>See the <i>Web Hooks</i> section of the BabySMS README.

            <h2>BabySMS Configuration:</h2>
            <ul>%s</ul>

            <h2>Web Hook Endpoints:</h2>
            <ul>%s</ul>
          </body>
        </html>
      HTML

      config_li = {
        web_hook_root: BabySMS.web_hook_root,
        strategy: BabySMS.strategy,
        adapters: BabySMS.adapters.map(&:adapter_id),
        available_adapters: BabySMS.available_adapters(test: true).map(&:adapter_name)
      }.map do |k, v|
        "<li>#{h k}: #{h v.inspect}</li>"
      end.join("")

      adapters = BabySMS.adapters.select { |a| a.web_hook }
      adapters_li = adapters.map do |a|
        rel_href = h(a.web_hook.mount_point)
        abs_href = h(a.web_hook.end_point)

        "<li><a href='#{rel_href}'>#{abs_href}</a><br>" \
        "<b>(#{h a.class.name} for #{h a.from})</b></li>"
      end.join("")

      sprintf(index_html, config_li, adapters_li)
    end
  end
end
