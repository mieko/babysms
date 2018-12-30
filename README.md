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

```ruby
BabySMS.adapter = BabySMS::Adapters::SomeAdapter.new(...)
msg = BabySMS::Message.new(recipient: '+1 555-555-5555', contents: 'Your Message')
msg.deliver_now
```

## Adapters
Each adapter uses the terminology of the service provider for configuration.  E.g., `api_key`
vs. `auth_token`, etc.  Other than `TestAdapter`, they all share a common `from` initialization
parameter to specify the number you're sending from.

You can configure multiple adapters (even instances of the same adapter with different
configurations) by assigning `BabySMS.adapters`.  BabySMS will attempt delivery with each adapter
in-order until one does not report an error.

### TestAdapter

The built-in testing adapter.  It stores outgoing texts in its `outbox`.  It prints colorful lines
to stdout when a message is sent for development purposes.  It is the default adapter.

`verbose` controls if it displays the outgoing SMS to stdout.

```ruby
BabySMS::Adapters::TestAdapter.new(verbose:)
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



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
