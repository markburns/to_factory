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
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency  'activerecord'


  spec.add_development_dependency "sqlite3" , "~> 1.3.6"

  case RUBY_VERSION
  when /^1.8.7/
    spec.add_dependency  'activerecord', ">2.0", "< 4.0"
    spec.add_dependency  'i18n', "< 0.7"
    spec.add_development_dependency "factory_girl", "<3.0"
    spec.add_development_dependency "ruby-debug"
  when /^1.9.\d/
    spec.add_development_dependency "factory_girl", "~> 4.5"
    spec.add_development_dependency "debugger"
  when /^2.\d/
    spec.add_development_dependency "factory_girl", "~> 4.5"
    spec.add_development_dependency "pry-byebug"
  end

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
