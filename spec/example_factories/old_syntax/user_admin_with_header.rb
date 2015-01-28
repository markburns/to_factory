Factory.define(:"to_factory/user") do |o|
  o.birthday "2014-07-08T15:30 UTC"
  o.email "test@example.com"
  o.name "Jeff"
  o.some_attributes({:a => 1})
  o.some_id 8
end

Factory.define(:admin, :parent => :"to_factory/user") do |o|
  o.birthday "2014-07-08T15:30 UTC"
  o.email "admin@example.com"
  o.name "Admin"
  o.some_attributes({:a => 1})
  o.some_id 9
end
