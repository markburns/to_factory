describe "ToFactory.generate!" do
  before do
    FileUtils.rm_rf "./tmp/factories"
    ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
    ToFactory::Project.create :name => "My Project", :objective => "easy testing", :some_id => 9
  end

  let(:user_file) do
    File.read("./tmp/factories/to_factory/user.rb")
  end

  let(:project_file) do
    File.read("./tmp/factories/to_factory/project.rb")
  end

  it "generates all factories" do
    ToFactory.generate!(:models => "spec/support", :factories => "tmp/factories")
    expect(user_file)   .to eq ToFactory(ToFactory::User.   first)
    expect(project_file).to eq ToFactory(ToFactory::Project.first)
  end
end
