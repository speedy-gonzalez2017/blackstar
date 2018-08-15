MRuby::Gem::Specification.new('blackstar') do |spec|
  spec.license = 'MIT'
  spec.author  = 'MRuby Developer'
  spec.summary = 'blackstar'
  spec.bins    = ['blackstar']

  spec.add_dependency 'mruby-print', core: 'mruby-print'
  spec.add_dependency 'mruby-mtest', mgem: 'mruby-mtest'
  spec.add_dependency 'mruby-process', github: 'iij/mruby-process'
  spec.add_dependency 'mruby-dir', github: 'iij/mruby-dir'
  spec.add_dependency 'mruby-string-ext', core: 'mruby-string-ext'
  spec.add_dependency 'mruby-thread', github: 'ppibburr/mruby-thread'
  spec.add_dependency 'mruby-io', github: 'iij/mruby-io'
  spec.add_dependency 'mruby-regexp-pcre', github: 'iij/mruby-regexp-pcre'
end
