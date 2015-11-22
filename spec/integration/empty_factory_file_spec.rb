describe "FileSync" do
  let(:user) { create_user!  }
  let(:admin) { create_admin!  }

  let(:empty_factory_file)             { File.read("./spec/example_factories/empty.rb") }

  before do
    FileUtils.rm_rf "./tmp/factories"
  end

  def user_file
    File.read("./tmp/factories/to_factory/user.rb") rescue nil
  end

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
