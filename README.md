ToFactory
=========
This is a little convenience gem for the scenario where
you find yourself writing factories for a pre-existing project.

E.g. they didn't have tests or they were using Test:Unit with fixtures but you prefer
RSpec and FactoryGirl.

Installation
___________

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
FactoryGirl.define
  factory :user do |u|
    email "test@example.com"
    name "Mike"
  end
end

```
