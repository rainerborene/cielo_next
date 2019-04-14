lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cielo/version"

Gem::Specification.new do |spec|
  spec.name          = "cielo_next"
  spec.version       = Cielo::VERSION
  spec.authors       = ["Rainer Borene"]
  spec.email         = ["rainerborene@gmail.com"]

  spec.summary       = "Yet another client to Cielo API"
  spec.description   = "Yet another client to Cielo API"
  spec.homepage      = "https://github.com/rainerborene/cielo_next"
  spec.license       = "MIT"

  spec.files         = %w(README.md Rakefile cielo_next.gemspec)
  spec.files        += Dir.glob("lib/**/*.rb")
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", [">= 0.7.4", "< 1.0"]
  spec.add_dependency "faraday_middleware", "~> 0.13"
  spec.add_dependency "hashie", [">= 3.4.6", "< 3.7.0"]
  spec.add_dependency "activesupport", ">= 4"

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "vcr", "~> 4.0"
  spec.add_development_dependency "webmock", "~> 3.5"
  spec.add_development_dependency "pry"
end
