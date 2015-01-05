# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'to_factory/version'

Gem::Specification.new do |spec|
  spec.name          = "to_factory"
  spec.version       = ToFactory::VERSION
  spec.authors       = ["Mark Burns"]
  spec.email         = ["markthedeveloper@gmail.com"]
  spec.summary     = %q{Turn ActiveRecord instances into factories}
  spec.description = %q{ActiveRecord::Base#to_factory method to create factory_girl definitions from real data}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}){ |f| File.basename(f) }.reject{|f| f== "spec" || f =="ci" }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "sqlite3" , "~> 1.3.6"

  if RUBY_VERSION =~ /^1\.8/
    spec.add_development_dependency "ruby-debug"
    spec.add_development_dependency "database_cleaner", "~> 0.3"
  else
    spec.add_development_dependency "database_cleaner", "~> 1.4.0"
  end

  if RUBY_VERSION =~ /^2\.\d/
    spec.add_development_dependency "pry-byebug"
  end

  old_active_record = RUBY_VERSION =~ /^1\.8|^1.9\.[1|2]/

  spec.add_dependency "ruby2ruby"
  spec.add_dependency "deep_merge"

  if old_active_record
    spec.add_dependency  'activerecord', ">2.0", "< 4.0"
    spec.add_dependency  'i18n', "< 0.7"
    spec.add_development_dependency "factory_girl", "< 2.0"
  else
    spec.add_dependency  'activerecord', ">3.0"
    spec.add_development_dependency "factory_girl", "~> 4.5"
  end

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
