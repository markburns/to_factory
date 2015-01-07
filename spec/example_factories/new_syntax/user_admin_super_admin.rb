FactoryGirl.define do
  factory(:admin, :parent => :"to_factory/user") do
    name "Admin"
  end

  factory(:super_admin, :parent => :admin) do
    name "Super Admin"
  end

  factory(:"to_factory/user") do
    name "User"
  end
end
