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

  spec.add_dependency "factory_bot", "~> 4.8.1"
  spec.add_dependency "ruby2ruby"
  spec.add_dependency "activerecord", "> 4.0"

  spec.add_development_dependency "sqlite3", "~> 1.3.6"
  spec.add_development_dependency "database_cleaner", "~> 1.5.1"

  spec.add_development_dependency "byebug"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 10.0"
end
