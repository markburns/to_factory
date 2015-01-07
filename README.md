:wrench:
=========
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

* auto-generate all factories
* adhoc generate from existing records
* unintrusively update factory files in place
* Parses and writes both new `FactoryGirl`, syntax or older `Factory.define` syntax

Tested against Ruby 1.8.7, 1.9.3, 2.0.0,  2.1.x, 2.2.0


# :file_folder:
# Installation

```ruby

#Gemfile
#add to whichever environments you want to generate data from
group :test, :development do
  gem 'to_factory'
end
```


# :warning:
# Warning
`ToFactory` writes into the `spec/factories` folder. Whilst it
is tested and avoids overwriting existing factories,
it is recommended that you execute after committing or when in a known
safe state.

# :computer:
# Example

```bash
git add spec/factories
git commit -m "I know what I am doing"
rails c
>ToFactory()
```

```ruby
#Generate all factories
ToFactory()
#outputs the first record of each ActiveRecord::Base subclass in the models folder
#to spec/factories

#Choose input/output directories
ToFactory.models    = "models/this/subfolder/only" #default "./app/models"
ToFactory.factories = "spec/support/factories"     #default "./spec/factories"
ToFactory()

#Exclude classes
ToFactory(exclude: [User, Project])

#Use Adhoc instances from the console
ToFactory User.last

#List defined factory names
ToFactory.definitions
#=> [:user, :admin, :project]


#writes to spec/factories/user.rb
FactoryGirl.define
  factory(:user) do |u|
    email "test@example.com"
    name "Mike"
  end
end

#doesn't overwrite existing factories
ToFactory User.last
#Exception =>
#ToFactory::AlreadyExists: an item for each of the following keys :user already exists

#Choose specific name
ToFactory :admin => User.last
#appends to spec/factories/user.rb

```

#Known bugs/limitations
* Factory generation does not follow a hierarchical order, so factory files may require manual editing for now.

#Other useful projects

If you are adding specs to an existing project you may want to look at:

* [rspec-kickstarter](https://github.com/seratch/rspec-kickstarter) (auto generate specs)
* [rspec-kickstarter-vintage](https://github.com/ifad/rspec-kickstarter-vintage) (for Ruby 1.8/Rspec 1.x)
* [hash_syntax](https://github.com/michaeledgar/hash_syntax) (convert 1.8 syntax to 1.9 and vice-versa)
* [transpec](https://github.com/yujinakayama/transpec) (convert old rspec syntax to new expect syntax)

