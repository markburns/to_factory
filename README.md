ToFactory
=========

[![Build Status](https://travis-ci.org/markburns/to_factory.svg)](https://travis-ci.org/markburns/to_factory)
[![Dependency Status](http://img.shields.io/gemnasium/markburns/to_factory.svg)](https://gemnasium.com/markburns/to_factory)
[![Code Climate](http://img.shields.io/codeclimate/github/markburns/to_factory.svg)](https://codeclimate.com/github/markburns/to_factory)
[![Test Coverage](https://codeclimate.com/github/markburns/to_factory/badges/coverage.svg)](https://codeclimate.com/github/markburns/to_factory)
[![Gem Version](http://img.shields.io/gem/v/to_factory.svg)](https://rubygems.org/gems/to_factory)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://markburns.mit-license.org)
[![Badges](http://img.shields.io/:badges-6/6-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

Easily add factories with valid data for an existing project.

Tested against Ruby 1.8.7, 1.9.2, 1.9.3, 2.0.0,  2.1.x

If you find yourself working on a project without tests/factories or only using fixtures,
then use this gem to quickly generate a factory from an existing object.

#Installation
___________

```ruby

#Gemfile
group :test, :development do
  gem 'to_factory'
end
```

#Usage

##Rails auto generation
_____
Generates a factory from the first record of each `ActiveRecord::Base` descendant
found in `app/models/**/*.rb`

###Rake

```bash
rake to_factory:all
```

###or from Ruby

```ruby
#Generate all factories
ToFactory.generate!

#Generate for specific classes
ToFactory.generate!(Project, User, Category, Post, Comment)

#Generate from the first three `Project` instances
ToFactory.generate!(Project => 3)


#Specify the folder
ToFactory.generate!(folder: "spec/support/factories")

#Place all generated factories in a single file
ToFactory.generate!(single_file: "spec/factories.rb")
```


##Adhoc
```bash
#rails console

> puts User.first.to_factory
#=>
FactoryGirl.define
  factory(:user) do |u|
    email "test@example.com"
    name "Mike"
  end
end

```

#Other useful projects

If you are adding specs to an existing project you may want to look at:

* [rspec-kickstarter](https://github.com/seratch/rspec-kickstarter) (auto generate specs)
* [rspec-kickstarter-vintage](https://github.com/ifad/rspec-kickstarter-vintage) (for Ruby 1.8/Rspec 1.x)
* [hash_syntax](https://github.com/michaeledgar/hash_syntax) (convert 1.8 syntax to 1.9 and vice-versa)
* [transpec](https://github.com/yujinakayama/transpec) (convert old rspec syntax to new expect syntax)

