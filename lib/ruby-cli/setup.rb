module RubyCLI
  module Setup
    def self.execute(name)
      raise "mruby-cli is not installed" unless RubyCLI::MRuby.installed?
      raise "bundler is not installed" unless RubyCLI::CRuby.installed?

      RubyCLI::MRuby.execute(name)
      RubyCLI::CRuby.execute(name)
    end
  end
end
