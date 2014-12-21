context "full integration, linting the output" do
  let(:user) do
    User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
  end

  it do
    require "factory_girl"
    factory = user.to_factory

    eval factory

    if FactoryGirl::VERSION =~ /^4\./
      FactoryGirl.lint
    end
  end

end

