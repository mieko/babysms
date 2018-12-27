lib = File.expand_path("../lib", __FILE__)
$:.unshift(lib) unless $:.include?(lib)
require "babysms/version"

Gem::Specification.new do |spec|
  spec.name          = "babysms"
  spec.version       = BabySMS::VERSION
  spec.authors       = ["Mike A. Owens"]
  spec.email         = ["mike@meter.md"]

  spec.summary       = "Simple Rails interface to a few SMS APIs"
  spec.description   = "Functionality to send SMS via Twilio, Nexmo, or debugging"
  spec.homepage      = "https://github.com/metermd/babysms"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/metermd/babysms"
    spec.metadata["changelog_uri"] = "https://github.com/metermd/babysms/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activemodel", "~> 5.2.1"
  spec.add_dependency "rainbow", "~> 3.0"
  spec.add_dependency "phony_rails", "~> 0.14"
  spec.add_dependency "twilio-ruby", "~> 5.18.0"
  spec.add_dependency "webmock", "~> 3.5.1"
  spec.add_dependency "shoulda-matchers", "~> 4.0.0.rc1"

  spec.add_development_dependency "bundler", ">= 1.17"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.0"
end
