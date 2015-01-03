describe ToFactory::ModelFinder do
  before do
    ToFactory.models = path
  end

  let(:finder) { ToFactory::ModelFinder.new }

  describe "#all" do
    let!(:user) { ToFactory::User.create! :name => "a user"}
    let!(:project) { ToFactory::Project.create! :name => "a project"}

    context "no match"do
      let(:path) { "tmp/doesnt_exist" }
      it do
        expect(finder.all).to eq []
      end
    end
    context "with a match" do
      let(:path) { "spec/support" }
      it do
        expect(finder.all).to match_array [user, project]
      end
    end
  end

end


