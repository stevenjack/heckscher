# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynamodb/exporter/version'

Gem::Specification.new do |spec|
  spec.name          = "dynamodb-exporter"
  spec.version       = Dynamodb::Exporter::VERSION
  spec.authors       = ["Steven Jack"]
  spec.email         = ["stevenmajack@gmail.com"]
  spec.summary       = %q{Exports data from dynamodb into JSON/YAML}
  spec.description   = %q{Allows you to export the data from a dynamodb table to JSON}
  spec.homepage      = "https://www.github.com/stevenjack/dynamodb-exporter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "aws-sdk"
end
