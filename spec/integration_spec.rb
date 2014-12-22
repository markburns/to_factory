context "full integration, linting the output" do
  let(:user) do
    ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
  end

  it "#to_factory" do
    require "factory_girl"
    factory = user.to_factory

    eval factory

    if FactoryGirl::VERSION =~ /^4\./
      FactoryGirl.lint
    end
  end

  context "AutoGenerator" do
    before do
      FileUtils.rm_rf "./tmp/factories"
      ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
      ToFactory::Project.create :name => "My Project", :objective => "easy testing", :some_id => 9
    end
    it  do
      generator = ToFactory::AutoGenerator.new(ToFactory::ModelFinder.new("./spec/support"), ToFactory::FileWriter.new("./tmp/factories"))
      generator.all!
    end
  end
end

