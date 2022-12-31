describe ToFactory::FileWriter do
  let(:file_writer) { ToFactory::FileWriter.new }
  let(:user_file_contents)    { File.read "./tmp/factories/to_factory/user.rb" }
  let!(:user) { create_user!  }
  let!(:admin) { create_admin! }
  let(:file_sync) { ToFactory::FileSync.new }
  let(:representations) { file_sync.all_representations }

  let(:expected) { File.read "./spec/example_factories/user_with_header.rb" }

  before do
    # sanity check generation isn't broken
    expect(representations.keys).to eq ["to_factory/user"]
    expect(representations.values[0][0]).to be_a ToFactory::Representation
  end

  it 'writes correctly' do
    file_writer.write representations

    expect(user_file_contents).to match_sexp expected
  end
end
