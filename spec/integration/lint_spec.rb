context "full integration" do
  let(:user) do
    ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
  end

  it "#to_factory linting the output" do
    require "factory_girl"
    if FactoryGirl::VERSION =~ /^4\./
      factory = user.to_factory

      eval factory

      FactoryGirl.lint
    end
  end
end

