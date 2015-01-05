FactoryGirl.define do
  factory(:"to_factory/admin", :parent => :"to_factory/user") do
    birthday "2014-07-08T13:30Z"
    email "admin@example.com"
    name "Admin"
    some_id 9
  end
end
