describe ToFactory::FileWriter do
  let(:fw) { ToFactory::FileWriter.new }
  let(:expected) { File.read "./spec/example_factories/user_with_header.rb" }
  let(:user_file_contents)    { File.read "./tmp/factories/to_factory/user.rb" }
  let!(:user) { create_user!  }
  let!(:admin) { create_admin! }

  it do
    fs = ToFactory::FileSync.new
    representations = fs.all_representations
    # sanity check generation isn't broken
    expect(representations.keys).to eq ["to_factory/user"]
    expect(representations.values[0][0]).to be_a ToFactory::Representation

    fw.write representations
    expect(user_file_contents).to match_sexp expected
  end
end
