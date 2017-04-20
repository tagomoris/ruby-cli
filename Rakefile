if ENV["PWD"] != "/home/mruby/code"
  # rake not in `docker-compose run compile`
  require "bundler/gem_tasks"
  task :default => :spec
end

RELEASE_PLATFORMS = %w(i386-apple-darwin14 x86_64-apple-darwin14 i686-pc-linux-gnu x86_64-pc-linux-gnu)

desc "build tarball for releasing on github"
task :tarball do
  require_relative 'lib/ruby-cli/version'
  require 'fileutils'
  RELEASE_PLATFORMS.each do |platform|
    project_root = Dir.getwd
    begin
      release_filename = "ruby-cli-#{RubyCLI::VERSION}-#{platform}.tgz"
      Dir.chdir(File.join(project_root, "mruby/build/#{platform}/bin"))
      sh "tar czf #{release_filename} ruby-cli"
    ensure
      Dir.chdir(project_root)
    end
    FileUtils.mv("mruby/build/#{platform}/bin/#{release_filename}", "#{release_filename}")
  end
end

require 'fileutils'

MRUBY_VERSION="1.2.0"

file :mruby do
  #sh "git clone --depth=1 https://github.com/mruby/mruby"
  sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/#{MRUBY_VERSION}.tar.gz -s -o - | tar zxf -"
  FileUtils.mv("mruby-#{MRUBY_VERSION}", "mruby")
end

APP_NAME=ENV["APP_NAME"] || "ruby-cli"
APP_ROOT=ENV["APP_ROOT"] || Dir.pwd

def setup_rake_for_mruby
  # avoid redefining constants in mruby Rakefile
  mruby_root=File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
  mruby_config=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
  ENV['MRUBY_ROOT'] = mruby_root
  ENV['MRUBY_CONFIG'] = mruby_config
  Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
  Dir.chdir(mruby_root)
  load "#{mruby_root}/Rakefile"
end

desc "compile binary"
task :compile => [:all] do
  setup_rake_for_mruby
  %W(#{mruby_root}/build/x86_64-pc-linux-gnu/bin/#{APP_NAME} #{mruby_root}/build/i686-pc-linux-gnu/#{APP_NAME}).each do |bin|
    sh "strip --strip-unneeded #{bin}" if File.exist?(bin)
  end
end

namespace :test do
  desc "run mruby & unit tests"
  # only build mtest for host
  task :mtest => :compile do
    # in order to get mruby/test/t/synatx.rb __FILE__ to pass,
    # we need to make sure the tests are built relative from mruby_root
    MRuby.each_target do |target|
      # only run unit tests here
      target.enable_bintest = false
      run_test if target.test_enabled?
    end
  end

  def clean_env(envs)
    old_env = {}
    envs.each do |key|
      old_env[key] = ENV[key]
      ENV[key] = nil
    end
    yield
    envs.each do |key|
      ENV[key] = old_env[key]
    end
  end

  desc "run integration tests"
  task :bintest => :compile do
    MRuby.each_target do |target|
      clean_env(%w(MRUBY_ROOT MRUBY_CONFIG)) do
        run_bintest if target.bintest_enabled?
      end
    end
  end
end

desc "run all tests"
Rake::Task['test'].clear
task :test => ["test:mtest", "test:bintest"]

desc "cleanup"
task :clean do
  sh "rake deep_clean"
end
