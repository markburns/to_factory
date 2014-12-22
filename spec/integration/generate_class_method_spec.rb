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
    expect(user_file)   .to eq ToFactory::User.   first.to_factory
    expect(project_file).to eq ToFactory::Project.first.to_factory
  end

  pending "specify classes" do
    ToFactory.generate!(ToFactory::Project)
    expect(project_file).to eq ToFactory::Project.first.to_factory
    expect(lambda{user_file}).to raise_error
  end

  pending "generates a number of records" do
    8.times do
      ToFactory::User.create :name => "Jeff", :email => "test@example.com", :some_id => 8
    end

    ToFactory.generate!(ToFactory::User => 3)
    expect(project_file).to eq ToFactory::User.first.to_factory
  end

  pending "places factories in a single file" do
    single_file = "tmp/factories/single_file.rb"
    ToFactory.generate!(file: single_file)

    expect(File.read(single_file)).to eq <<-FILE.strip_heredoc
      FactoryGirl.define do
        factory :"to_factory/user" do
          name "Jeff"
          email "test@example.com"
          some_id 8
        end

        factory :"to_factory/project" do
          name "My project"
          object "easy testing"
          some_id 9
        end
      end
    FILE

    require single_file
    FactoryGirl.lint
  end
end
