describe "AutoGenerator" do
  let(:user) do
    ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
  end

  before do
    FileUtils.rm_rf "./tmp/factories"
    ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
    ToFactory::Project.create :name => "My Project", :objective => "easy testing", :some_id => 9
  end

  let(:user_file) do
    File.read("./tmp/factories/to_factory/user.rb")
  end

  let(:project_file) do
    File.read("./tmp/factories/to_factory/user.rb")
  end

  it do
    generator = ToFactory::AutoGenerator.new("./spec/support", "./tmp/factories")
    generator.all!

    expect(user_file   ).to eq ToFactory::User.first.to_factory
    expect(project_file).to eq ToFactory::User.first.to_factory
  end

end
