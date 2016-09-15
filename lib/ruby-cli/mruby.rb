module RubyCLI
  module MRuby
    def self.installed?
      system("mruby-cli --help >/dev/null 2>&1")
    end

    def self.execute(name)
      system("mruby-cli -s #{name}")
    end
  end
end
