require 'babysms'
require 'babysms/microweb'
require 'json'

module BabySMS
  class Feedback
    include Microweb

    INDEX_HTML = <<~"EOD".freeze
      <!DOCTYPE html>
        <head>
          <title>BabySMS #{h BabySMS::VERSION} Feedback Endpoint</title>
          <style>
            html { margin: 4em; font-family: monospace; }
            body { max-width: 45em; }
            h2 { margin-top: 2em; }
          </style>
        </head>
        <body>
          <h1>BabySMS #{h BabySMS::VERSION} Feedback Endpoint</h1>
            <p>BabySMS is reachable here to allow SMS providers to contact your webhooks.</p>
            <p>This application endpoint should be off-limits to world at large, either via password
               protection, host-based authorization, or both.
            <p>See the <i>Feedback &amp; Webhooks</i> section of the BabySMS README.
          <h2>Active Adapters:</h2>
          <ul>%s</ul>
        </body>
      </html>
    EOD

    get '/' do |request, response|
      response.headers['Content-Type'] = "text/html;charset=utf-8"
      adapters = BabySMS.adapters.select { |a| a.respond_to?(:feedback) }

      adapters_li = adapters.map do |a|
        "<li>/#{h a.adapter_id} <b>(#{h a.class.name} for #{h a.from})</b></li>"
      end.join("")

      sprintf(INDEX_HTML, adapters_li.empty? ? "<li><em>(none)</em></li>" : adapters_li)
    end

    BabySMS.adapters.each do |adapter|
      if adapter.respond_to?(:feedback)
        get "/#{adapter.adapter_id}" do |request, response|
          adapter.feedback(request, response)
        end
      end
    end
  end
end
