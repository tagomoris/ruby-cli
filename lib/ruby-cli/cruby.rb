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
        inject_to_gemspec(name)
        inject_to_rakefile
        FileUtils.rm_rf cruby_dir_tmp
      ensure
        Dir.chdir original_working_dir
      end
    end

    def self.inject_to_gemspec(name)
      content_header = <<-EOF
MRUBY_CLI_FILES = %w(Dockerfile bintest build_config.rb docker-compose.yml mrbgem.rake mrblib tools)

EOF
      reject_mruby_files = '.reject{|f| MRUBY_CLI_FILES.any?{|s| f.start_with?(s) } }'

      gemspec_filename = "#{name}.gemspec"
      gemspec_tmp_filename = "#{gemspec_filename}.tmp"
      File.open(gemspec_tmp_filename, "a") do |f|
        File.open(gemspec_filename) do |r|
          r.readlines.each do |line|
            if line.start_with?("Gem::Specification")
              f.puts content_header
              f.write line
            elsif line =~ /spec\.files/
              f.puts line.chomp + reject_mruby_files
            else
              f.write line
            end
          end
        end
      end
      File.delete(gemspec_filename)
      File.rename(gemspec_tmp_filename, gemspec_filename)
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
