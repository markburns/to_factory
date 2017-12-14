FactoryBot.define do
  factory(:"to_factory/user") do
    name "User"
  end

  factory(:admin, parent: :"to_factory/user") do
    name "Admin"
  end

  factory(:super_admin, parent: :admin) do
    name "Super Admin"
  end
end
