lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "babysms/version"

Gem::Specification.new do |spec|
  spec.name = "babysms"
  spec.version = BabySMS::VERSION
  spec.authors = ["Mike A. Owens"]
  spec.email = ["mike@filespanker.com"]

  spec.summary = "Ruby SMS Wrangler"
  spec.description = "Bidirectional SMS via Twilio, Bandwidth, Nexmo, Plivo, SignalWire..."
  spec.homepage = "https://github.com/mieko/babysms"
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/mieko/babysms"
    spec.metadata["changelog_uri"] = "https://github.com/mieko/babysms/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.2.1"
  spec.add_dependency "phony", ">= 0.14"
  spec.add_dependency "rainbow", ">= 3.0"
  spec.add_dependency "sinatra", "~> 2.0"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.0"

  spec.add_development_dependency "rack-test", "~> 1.1"
  spec.add_development_dependency "twilio-ruby", ">= 5.18.0"
  spec.add_development_dependency "nexmo", ">= 5.5.0"
  spec.add_development_dependency "ruby-bandwidth", ">= 1.0.20"
  spec.add_development_dependency "plivo", ">= 4.1.6"
  spec.add_development_dependency "signalwire", "~> 2.2"
end
