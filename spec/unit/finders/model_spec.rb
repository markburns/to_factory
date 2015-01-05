describe ToFactory::Finders::Model do
  before do
    ToFactory.models = path
  end

  let(:finder) { ToFactory::Finders::Model.new }

  describe "#call" do
    let!(:user) { ToFactory::User.create! :name => "a user"}
    let!(:project) { ToFactory::Project.create! :name => "a project"}

    context "no match"do
      let(:path) { "./tmp/doesnt_exist" }
      it do
        expect(finder.call).to eq []
      end
    end
    context "with a match" do
      let(:path) { "./spec/support/models" }
      it do
        expect(finder.call).to match_array [user, project]
      end
    end
  end

end


