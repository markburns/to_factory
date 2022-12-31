# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "to_factory/version"

Gem::Specification.new do |spec|
  spec.name          = "to_factory"
  spec.version       = ToFactory::VERSION
  spec.authors       = ["Mark Burns"]
  spec.email         = ["markthedeveloper@gmail.com"]
  spec.summary     = "Turn ActiveRecord instances into factories"
  spec.description = "Autogenerate and append/create factory_bot definitions from the console"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }.reject { |f| f == "spec" || f == "ci" }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "factory_bot"
  spec.add_dependency "ruby2ruby"

  spec.add_development_dependency "activerecord"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "database_cleaner"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"

  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rspec-github'

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
end
