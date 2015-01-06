Factory.define(:admin, :parent => :"to_factory/user") do |o|
  o.name "Admin"
end

Factory.define(:super_admin, :parent => :admin) do |o|
  o.name "Super Admin"
end

Factory.define(:"to_factory/user") do |o|
  o.name "User"
end
