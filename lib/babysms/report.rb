module BabySMS

  # With some adapters, a web hook call can represent more than one logical action, e.g.,
  # multiple messages received, multiple failed SMS sent, etc.
  #
  # Adapters report each logical "event" to a Report instance, which massages them into Inbox
  # messages and saves them.  When they've all been reported, Report#dispatch_all will dispatch
  # them to interested inboxes.

  class Report
    attr_reader :adapter
    attr_reader :log

    def initialize(adapter)
      @adapter = adapter
      @log = []
    end

    def incoming_message(message)
      log.push([:receive, { message: message }])
    end

    def dispatch_all
      inboxes = BabySMS.inboxes.select { |inbox| inbox.relevant_for?(adapter) }

      log.each do |log_entry|
        inboxes.each do |inbox|
          inbox.send(*log_entry)
        end
      end
    end
  end
end
