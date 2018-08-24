require 'dotenv'
Dotenv.load("./.env")
require 'fileutils'
Dir.glob('tasks/*.rake').each { |r| load r}

MRUBY_VERSION="1.2.0"

file :mruby do
  #sh "git clone --depth=1 https://github.com/mruby/mruby"
  sh "curl -L --fail --retry 3 --retry-delay 1 https://github.com/mruby/mruby/archive/1.2.0.tar.gz -s -o - | tar zxf -"
  FileUtils.mv("mruby-1.2.0", "mruby")
end

APP_NAME=ENV["APP_NAME"] || "blackstar"
APP_ROOT=ENV["APP_ROOT"] || Dir.pwd
# avoid redefining constants in mruby Rakefile
mruby_root=File.expand_path(ENV["MRUBY_ROOT"] || "#{APP_ROOT}/mruby")
mruby_config=File.expand_path(ENV["MRUBY_CONFIG"] || "build_config.rb")
ENV['MRUBY_ROOT'] = mruby_root
ENV['MRUBY_CONFIG'] = mruby_config
Rake::Task[:mruby].invoke unless Dir.exist?(mruby_root)
Dir.chdir(mruby_root)
load "#{mruby_root}/Rakefile"

desc "compile binary"
task :compile => [:all] do
  binaries = [
    {arhitect: 'linux-x64', file: "#{mruby_root}/build/x86_64-pc-linux-gnu/bin/#{APP_NAME}"},
    {arhitect: 'win-x32.exe', file: "#{mruby_root}/build/i686-w64-mingw32/bin/#{APP_NAME}.exe"},
  ]

  binaries.each do |bin|
    sh "strip --strip-unneeded #{bin[:file]}" if File.exist?(bin[:file])
  end

  binaries.each do |bin|
    sh "cp #{bin[:file]} #{__dir__}/builds/#{bin[:arhitect]}" if File.exist?(bin[:file])
  end
end

desc "run"
task :run do
  Rake::Task['compile'].invoke
  exec_path = "#{__dir__}/mruby/build/x86_64-pc-linux-gnu/bin/blackstar"
  sh exec_path
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

desc "commit"
task "commit" do
  config_fn = -> (options) do
    sh "git config --global user.name '#{options[:name]}'"
    sh "git config --global user.email '#{options[:email]}'"
  end

  config_fn.call({name: 'Anonymous', email: '<>'})

  sh "git add ../"
  sh "git commit -m 'update'"
  sh "git push origin master --force"

  config_fn.call({name: ENV["GIT_NAME"], email: ENV["GIT_EMAIL"]})
end