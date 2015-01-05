Factory.define(:"to_factory/user") do |o|
  o.birthday "2014-07-08T15:30Z"
  o.email "test@example.com"
  o.name "Jeff"
  o.some_id 8
end

Factory.define(:admin, :parent => :"to_factory/user") do |o|
  o.birthday "2014-07-08T15:30Z"
  o.email "admin@example.com"
  o.name "Admin"
  o.some_id 9
end
