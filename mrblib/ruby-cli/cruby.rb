begin
  FileUtils
rescue NameError
  FileUtils = FileUtilsSimple
end

module RubyCLI
  module CRuby
    def self.installed?
      system("bundle gem -h >/dev/null 2>&1")
    end

    def self.execute(name)
      original_working_dir = Dir.getwd
      project_root_dir = File.join(Dir.getwd, name)
      begin
        cruby_dir_tmp = File.join(Dir.getwd, name, ".gen-cruby")
        FileUtils.mkdir_p cruby_dir_tmp
        Dir.chdir cruby_dir_tmp
        system("bundle gem #{name}")

        Dir.chdir File.join(cruby_dir_tmp, name)
        ["Gemfile", "README.md", "bin", "lib", "#{name}.gemspec"].each do |e|
          FileUtils.mv(e, File.join(project_root_dir, e))
        end

        Dir.chdir project_root_dir
        inject_to_rakefile
        FileUtils.rmdir_rf cruby_dir_tmp
      ensure
        Dir.chdir original_working_dir
      end
    end

    def self.inject_to_rakefile
      content = <<-EOF
if ENV["PWD"] != "/home/mruby/code"
  # rake not in "docker-compose run compile"
  require "bundler/gem_tasks"
  task :default => :spec
end

EOF
      File.open("Rakefile.tmp", "a") do |f|
        f.write content
        File.open("Rakefile") do |r|
          f.write r.read
        end
      end
      File.delete("Rakefile")
      File.rename("Rakefile.tmp", "Rakefile")
    end
  end
end
