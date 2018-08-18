def gem_config(conf)
  #conf.gembox 'default'

  # be sure to include this gem (the cli app)
  conf.gem File.expand_path(File.dirname(__FILE__))

  conf.gem core: 'mruby-print'
  conf.gem core: 'mruby-string-ext'

  conf.gem mgem: 'mruby-mtest'

  conf.gem :git => 'https://github.com/iij/mruby-dir'
  conf.gem :git => 'https://github.com/iij/mruby-io'
  conf.gem :git => 'https://github.com/iij/mruby-iijson'

  conf.gem :git => 'https://github.com/appPlant/mruby-process'

  conf.gem :git => 'https://github.com/matsumotory/mruby-sleep'

  conf.gem :git => 'https://github.com/mattn/mruby-base64'

  conf.gem :git => 'https://github.com/ksss/mruby-at_exit'
end

MRuby::Build.new do |conf|
  toolchain :clang

  conf.enable_bintest
  conf.enable_debug
  conf.enable_test

  gem_config(conf)
end

MRuby::Build.new('x86_64-pc-linux-gnu') do |conf|
  conf.gem :git => 'https://github.com/iij/mruby-regexp-pcre'
  toolchain :gcc

  gem_config(conf)
end


# MRuby::CrossBuild.new('x86_64-w64-mingw32') do |conf|
#   toolchain :gcc
#
#   [conf.cc, conf.linker].each do |cc|
#     cc.command = 'x86_64-w64-mingw32-gcc'
#   end
#   conf.cxx.command      = 'x86_64-w64-mingw32-cpp'
#   conf.archiver.command = 'x86_64-w64-mingw32-gcc-ar'
#   conf.exts.executable  = ".exe"
#
#   conf.build_target     = 'x86_64-pc-linux-gnu'
#   conf.host_target      = 'x86_64-w64-mingw32'
#
#   gem_config(conf)
# end


MRuby::CrossBuild.new('i686-w64-mingw32') do |conf|
  toolchain :gcc

  [conf.cc, conf.linker].each do |cc|
    cc.command = 'i686-w64-mingw32-gcc'
  end
  conf.cxx.command      = 'i686-w64-mingw32-cpp'
  conf.archiver.command = 'i686-w64-mingw32-gcc-ar'
  conf.exts.executable  = ".exe"

  conf.build_target     = 'i686-pc-linux-gnu'
  conf.host_target      = 'i686-w64-mingw32'

  gem_config(conf)
end
