describe ToFactory::Finders::Model do
  before do
    ToFactory.models = path
  end

  let(:finder) { ToFactory::Finders::Model.new }
  let(:path) { "./spec/support/models" }

  describe "#call" do
    let!(:user) { ToFactory::User.create! name: "a user" }
    let!(:project) { ToFactory::Project.create! name: "a project" }

    context "with a match" do
      it do
        expect(finder.call).to match_array [user, project]
      end
    end

    context "no match"do
      let(:path) { "./tmp/doesnt_exist" }
      it do
        expect(finder.call).to eq []
      end
    end

    context "with an invalid model file" do
      let(:path) { "./spec/support/broken_models" }
      before do
        allow(finder).to receive(:warn)
      end

      it "displays a warning" do
        expect(finder.call).to eq [project]

        expect(finder).to have_received(:warn)
          .with("Failed to eval ./spec/support/broken_models/invalid_ruby_file.rb")
      end
    end

    context "with an invalid class" do
      before do
        allow(finder).to receive(:warn)
      end

      it "displays a warning" do
        klass = double("BrokenClass", inspect: "BrokenClass")
        expect(klass).to receive(:ancestors).and_raise("Some error")
        finder.call(klasses: [klass])

        expect(finder).to have_received(:warn)
          .with("Failed to get record from BrokenClass \"Some error\"")
      end
    end
  end
end
