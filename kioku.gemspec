# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kioku/version'

Gem::Specification.new do |spec|
  spec.name          = "kioku"
  spec.version       = Kioku::VERSION
  spec.authors       = ["Brandon Pittman"]
  spec.email         = ["brandonpittman@gmail.com"]
  spec.summary       = %q{A simple one-line-a-day journaling app.}
  spec.description   = %q{A simple one-line-a-day journaling app.}
  spec.homepage      = "http://github.com/brandonpittman/kioku"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.executables   = ['kioku']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.18"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
