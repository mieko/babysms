module BabySMS
  class InvalidMessage < BabySMS::Error
  end

  class Message
    attr_accessor :to
    attr_accessor :from
    attr_accessor :contents

    def initialize(to:, from: nil, contents:)
      @to = Phony.normalize(to)
      @from = from
      @contents = contents
    end

    def deliver(adapters: BabySMS.adapters, strategy: BabySMS.strategy)
      validate!
      BabySMS::MailMan.new(adapters: adapters, strategy: strategy).deliver(self)
    end

    # generates and delivers a reply to a message
    def reply(contents:, adapters: BabySMS.adapters, strategy: BabySMS.strategy)
      Message.new(to: from, from: to, contents: contents)
             .deliver(adapters: adapters, strategy: strategy)
    end

    private

    MAX_CONTENTS_LENGTH = 1600

    def validate!
      validate_to!
      validate_contents!
    end

    def validate_to!
      if to.nil? || to.empty?
        fail BabySMS::InvalidMessage, 'no to:'
      end

      unless Phony.plausible?(to)
        fail BabySMS::InvalidMessage, "implausible to: #{to}"
      end
    end

    def validate_contents!
      if contents.nil? || contents.empty?
        fail BabySMS::InvalidMessage, 'no contents'
      end

      if contents.size > MAX_CONTENTS_LENGTH
        msg = "contents too long (#{contents.size} vs max of #{MAX_CONTENTS_LENGTH}); " \
              "contents: `#{contents}`"
        fail BabySMS::InvalidMessage, msg
      end
    end
  end
end
