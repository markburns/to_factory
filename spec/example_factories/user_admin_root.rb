FactoryBot.define do
  factory(:"to_factory/user") do
    name("User")
  end

  factory(:admin, parent: :"to_factory/user") do
    name("Admin")
  end

  factory(:root, parent: :"to_factory/user") do
    birthday "2014-07-08T15:30 UTC"
    email "test@example.com"
    name "Jeff"
    some_attributes(a: 1)
    some_id 8
  end

  factory(:super_admin, parent: :admin) do
    name("Super Admin")
  end
end
