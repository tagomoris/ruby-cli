# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby-cli/version'

MRUBY_CLI_FILES = %w(Dockerfile bintest build_config.rb docker-compose.yml mrbgem.rake mrblib tools)

Gem::Specification.new do |spec|
  spec.name          = "ruby-cli"
  spec.version       = RubyCLI::VERSION
  spec.authors       = ["TAGOMORI Satoshi"]
  spec.email         = ["tagomoris@gmail.com"]

  spec.summary       = %q{Generate a code tree for both of rubygems and mruby-cli}
  spec.description   = %q{This tool generates a code tree by merging result of "bundle gem" and "mruby-cli -s"}
  spec.homepage      = "https://github.com/tagomoris/ruby-cli"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }.reject{|f| MRUBY_CLI_FILES.any?{|s| f.start_with?(s) } }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
