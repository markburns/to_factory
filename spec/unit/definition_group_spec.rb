describe ToFactory::DefinitionGroup do
  let(:user) { create_user! }
  let(:admin) { create_admin! }
  let(:user_definition) { ToFactory::Generator.new(user, "user").to_factory }
  let(:admin_definition) { ToFactory::Generator.new(admin, "admin").to_factory }
  let(:group) { ToFactory::DefinitionGroup.new }

  it do
    result = group.perform([[:user, user], [:admin, admin]])

    expect(result.keys[0]).to eq ToFactory::User
    expect(result.values[0]).to eq({:user => user_definition,
                                    :admin => admin_definition})
  end

  it "#calculate_name" do
    expect(group.calculate_name(ToFactory::Project)).to eq "to_factory/project"
  end
end
