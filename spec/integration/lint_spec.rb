context "full integration" do
  let(:user) do
    ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8, :birthday => Time.now
  end

  it "#to_factory linting the output" do
    require "factory_girl"
    if FactoryGirl::VERSION =~ /^4\./
      ToFactory(user)

      load "./tmp/factories/to_factory/user.rb"

      FactoryGirl.lint
    end
  end
end

