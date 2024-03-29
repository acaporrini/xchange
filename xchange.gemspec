# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xchange/version'

Gem::Specification.new do |spec|
  spec.name          = "xchange"
  spec.version       = Xchange::VERSION
  spec.authors       = ["acaporrini"]
  spec.email         = ["a.caporrini@gmail.com"]
  spec.summary       = "A Library for dealing with currency conversion and operations between different currencies."
  spec.homepage      = "http://rubygems.org/gems/xchange"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
end
