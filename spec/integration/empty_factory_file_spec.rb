describe "Empty File spec" do
  let(:user) { create_user!  }

  context "with an empty factory file" do
    before do
      user
      FileUtils.mkdir_p "./tmp/factories/to_factory"

      File.open("./tmp/factories/to_factory/empty.rb", "w") do |f|
        f << " "
        f << "\n "
      end
    end

    it "doesn't blow up" do
      ToFactory(:empty => OpenStruct.new({attributes: {}}), :user => user)
    end
  end
end
