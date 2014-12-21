context "full integration, linting the output" do
  let(:user) do
    User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
  end

  it do
    require "factory_girl"
    factory = user.to_factory

    eval factory

    FactoryGirl.lint
  end

end

