describe ToFactory::DefinitionGroup do
  let(:user) { create_user! }
  let(:admin) { create_admin! }
  let(:user_definition) { File.read "./spec/example_factories/#{version}_syntax/user.rb"}
  let(:admin_definition) { File.read "./spec/example_factories/#{version}_syntax/admin.rb"}
  let(:group) { ToFactory::DefinitionGroup.new }

  it do
    result = group.perform([[:"to_factory/user", user], [:admin, admin]])

    expect(result.keys[0]).to eq ToFactory::User
    expect(result.values[0][:"to_factory/user"]).to match_sexp user_definition
    expect(result.values[0][:admin]).to match_sexp admin_definition
  end

  it "#calculate_name" do
    expect(group.calculate_name(ToFactory::Project)).to eq "to_factory/project"
  end
end
