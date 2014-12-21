ToFactory
=========

[![Build Status](https://travis-ci.org/markburns/to_factory.svg?branch=master)](https://travis-ci.org/markburns/to_factory)
Easily add factories with valid data for an existing project.

If you find yourself working on a project without tests/factories or only using fixtures,
then use this gem to quickly generate a factory from an existing object.

Installation
___________

```ruby

#Gemfile
group [:test, :development] do
  gem 'to_factory'
end
```

Usage
_____

```ruby
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

