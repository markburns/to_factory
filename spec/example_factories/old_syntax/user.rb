Factory.define(:"to_factory/user") do |o|
  o.birthday "2014-07-08T15:30Z"
  o.email "test@example.com"
  o.name "Jeff"
  o.some_attributes({:a => 1})
  o.some_id 8
end
