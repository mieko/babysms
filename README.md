# BabySMS

BabySMS is a small Ruby interface to a few outgoing SMS services.  It lets you send off SMS
messages fire-and-forget style, with fallbacks on network failure and minor load-balancing
of providers for throttling.


## Installation

Add these lines to your application's `Gemfile`:

```ruby
gem 'YourAPIProviderGem' # see below
gem 'babysms', '~> 0.5', github: 'mieko/babysms'
```

## Usage

```ruby
# Usually in an initializer
BabySMS.adapter = BabySMS::Adapters::SomeAdapter.new(...)

# elsewhere:
msg = BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Your Message')
msg.deliver
```


## Messages

`BabySMS::Message#deliver` can accept an `adapters` keyword argument to override the global
adapters list in `BabySMS.adapter[s]`.

BabySMS will attempt delivery with each adapter in-order until one succeeds, or will raise
`BabySMS::FailedDelivery` once exhausted.

`#deliver` returns a `BabySMS::Receipt`.  This allows you to inspect (and log) adapters that failed
along the way to delivery.  Use `#exceptions?` to discover if something is
failing, and `#exceptions` to see the list of failed deliveries before the successful one.


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

`verbose` controls if it displays the outgoing SMS to stderr.  `fails` determines if deliveries
will fail.

```ruby
BabySMS::Adapters::TestAdapter.new(verbose: true, fails: false)
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

## Credits

BabySMS was written by Mike A. Owens <mike@filespanker.com>

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
