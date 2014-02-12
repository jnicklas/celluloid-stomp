# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'celluloid/stomp/version'

Gem::Specification.new do |spec|
  spec.name          = "celluloid-stomp"
  spec.version       = Celluloid::Stomp::VERSION
  spec.authors       = ["Jonas Nicklas", "Kim Burgestrand"]
  spec.email         = ["jonas.nicklas@gmail.com", "kim@burgestrand.se"]
  spec.summary       = %q{Evented Celluloid STOMP reactor}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
