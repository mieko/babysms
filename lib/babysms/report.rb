module BabySMS
  class Report
    attr_reader :adapter
    attr_reader :log

    def initialize(adapter)
      @adapter = adapter
      @log = []
    end

    def incoming_message(message)
      log.push([adapter, :incoming_message, { message: message }])
    end
  end
end
