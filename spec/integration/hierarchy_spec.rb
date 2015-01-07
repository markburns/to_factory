describe ToFactory::Parsing::Hierarchy do
  let(:hierarchy) { ToFactory::Parsing::Hierarchy.new }

  let(:input) do
    [
      [:root,                 :admin,             "root def"],
      [:"to_factory/project", nil,                "project def"],
      [:admin,                :"to_factory/user", "admin def"],
      [:"to_factory/user",    nil,                "user def"],
      [:sub_project, :"to_factory/project",       "subproject def"]
    ]
  end

  it "organizes an array of factories" do
    lists = hierarchy.organize(input)

    expect(lists[0].klass).to eq ToFactory::User
    expect(lists[1].klass).to eq ToFactory::Project

    expect(lists[0].to_a).to eq ["user def","admin def", "root def"]
    expect(lists[1].to_a).to eq ["project def", "subproject def"]
  end
end
