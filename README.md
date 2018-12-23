# BabySMS

BabySMS is a small Rails API interface to a few SMS messaging services.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'babysms'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install babysms

## Usage

BabySMS.adapter = BabySMS::Adapters::{Test,Twilio,Nexmo}Adapter.new
msg = BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Your Message')
msg.deliver_now


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
