Factory.define(:"to_factory/user") do |o| 
  o.name("User") 
end

Factory.define(:root, :parent => :"to_factory/user") do |o|
  o.birthday "2014-07-08T15:30Z"
  o.email "test@example.com"
  o.name "Jeff"
  o.some_attributes({:a => 1})
  o.some_id 8
end


Factory.define(:admin, :parent => :"to_factory/user") do |o|
  o.name("Admin")
end

Factory.define(:super_admin, :parent => :admin) do |o| 
  o.name("Super Admin") 
end

