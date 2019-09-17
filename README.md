# BabySMS

BabySMS is a Ruby interface to a decent collection of SMS service providers.  With it, you can
fire and forget SMS messages, or script entire two-way SMS conversations.  All without tying
yourself to a single provider.

The interface stays the same, So you can comparison-shop for prices or reliability.

BabySMS allows multiple services to be used at once for failover, or random selection of a
provider for load-balancing (against throttling.)


## Installation

Add these lines to your application's `Gemfile`:

```ruby
gem 'YourAPIProviderGem' # see below
gem 'babysms', '~> 0.5'
```

## Usage

### Basic
```ruby
BabySMS.adapter = BabySMS::Adapters::SomeAdapter.new(...)

BabySMS::Message.new(to: '+1 555-555-5555', contents: 'Hello, World!').deliver
```

If you need just basic outgoing functionality, that's all there is to it.

### Multiple Adapters for Reliability
```ruby
BabySMS.adapters = [
  BabySMS::Adapters::HooliAdapter.new(...),
  BabySMS::Adapters::PiedPiperAdapter.new(...)
]

BabySMS.strategy = :in_order
BabySMS::Message.new(...).deliver
```

This will try `HooliAdapter` first, but if it fails, `PiedPiperAdapter`.  Changing the `strategy`
to `:random` will go through the list randomly, providing something akin to load-balancing.

## Sending Messages

`BabySMS::Message#deliver` can directly accept an `adapters` keyword argument that overrides the
global adapters list in `BabySMS.adapter[s]`.

BabySMS will attempt delivery with each adapter until one succeeds, or will raise
`BabySMS::FailedDelivery` once exhausted.

`#deliver` returns a `BabySMS::Receipt`.  This allows you to inspect (and log) adapters that failed
along the way to delivery.  Use `#exceptions?` to discover if something is failing, and
`#exceptions` to see the list of failed deliveries before the successful one.

## Receiving Messages

*Note: This functionality is currently being implemented.*

The API providers report incoming messages to you by accessing a publicly-available URL.  This means
you have to have a web server running on the open internet to receive and process incoming messages

`BabySMS::WebApplication` is a Rack (Sinatra) application that does just that.

```ruby
# config.ru
require 'babysms'
require 'babysms/web_application'

# Replace this with your service provider as listed below
BabySMS.adapter = BabySMS::TestAdapter.new

# Publicly-accessible URL
BabySMS.web_hook_root = "https://example.com/_babysms"

BabySMS.inbox = BabySMS::Inbox.new do
  receive do |message|
    puts "Incoming message from #{message.from}:\n"
    puts "  > #{message.contents}"

    # Replies with same number/adapter, regardless of strategy
    message.reply(contents: "Thank you for your message.")
  end
end

run BabySMS::WebApplication.new
```

You'll need to secure the web-application against the general public, allowing only your SMS
providers to access them.

*TODO: Explain exactly how to do that with Rack*

## Rails Integration

*TODO: Write about mounting BabySMS::WebApplication in routes.rb, sending messages via ActiveJob,
etc*

## Adapters

Each adapter uses the terminology of the service provider for configuration.  E.g., `api_key`
vs. `auth_token`, etc.  Other than `TestAdapter`, they all share a common `from` initialization
parameter to specify the number you're sending from.

You can configure multiple adapters (even instances of the same adapter class with different
configurations) by assigning `BabySMS.adapters` or using the `adapters:` argument to
`Message#deliver`.

Adapters require external gems to interface with their respective services.  You will have to
require these gems yourself, and *before* `babysms`: BabySMS enables functionality by feature-
detecting these gems.

Putting it before `babysms` in your `Gemfile` should work.


### TestAdapter

The built-in testing adapter.  It stores outgoing texts in its `outbox`.  It prints colorful lines
to stderr when a message is sent for development purposes.  It is the default adapter.

`verbose:` controls if it displays the outgoing SMS to stderr.  `fails:` determines if deliveries
will fail.

```ruby
BabySMS::Adapters::TestAdapter.new(verbose: true, fails: false, from: '15555555555')
```


### BandwidthAdapter

Requires the `ruby-bandwidth` gem.

```ruby
BabySMS::Adapters::BandwidthAdapter.new(user_id:, api_token:, api_secret:, from:)
```


### TwilioAdapter

Requires the `twilio-ruby` gem.

```ruby
BabySMS::Adapters::TwilioAdapter.new(account_sid:, auth_token:, from:)
```


### NexmoAdapter

Requires the `nexmo` gem.

```ruby
BabySMS::Adapters::NexmoAdapter.new(api_key:, api_secret:, from:)
```


### PlivoAdapter

Requires the `plivo-ruby` gem.

```ruby
BabySMS::Adapters::PlivoAdapter.new(auth_id:, auth_token:, from:)
```


### SignalwireAdapter

Requires the `signalwire` gem.

```ruby
# Notice the capitalization, to be consistent with their SDK naming
BabySMS::Adapters::SignalwireAdapter.new(from:, project:, token:, space_url:)
```

## Credits

BabySMS was written by Mike A. Owens <mike@filespanker.com>

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
