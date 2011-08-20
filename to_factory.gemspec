# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "to_factory/version"

Gem::Specification.new do |s|
  s.name        = "to_factory"
  s.version     = ToFactory::VERSION
  s.authors     = ["Mark Burns"]
  s.email       = ["markthedeveloper@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Turn ActiveRecord instances into factories}
  s.add_dependency('factory_girl_rails')

  s.description = %q{This gem gives the object.to_factory method to give a formatted string version of an ActiveRecord object that can be used by factory_girl}

  s.rubyforge_project = "to_factory"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
