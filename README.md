ToFactory
=========
This is a little convenience gem for the scenario where
you find yourself writing factories for a pre-existing project.

E.g. they didn't have tests or they were using Test:Unit with fixtures but you prefer
RSpec and FactoryGirl.

Installation
___________

I've only tried this out with a Rails 3, Ruby 1.8.7 project.

```ruby

#Gemfile
group [:test, :development] do
  gem 'to_factory'
end
```


```bash
bundle install
```

Usage
_____

```ruby
#rails console

> puts User.first.to_factory

#=>
Factory.define :user do |u|
  u.email "test@example.com"
  u.name "Mike"
end

```
