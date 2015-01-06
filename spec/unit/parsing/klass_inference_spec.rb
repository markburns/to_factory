describe ToFactory::Parsing::KlassInference do
  let(:inference) { ToFactory::Parsing::KlassInference.new }

  mappings = #klass, parent, result
    [:admin,        :"to_factory/user",    ToFactory::User],
    [:some_project, :"to_factory/project", ToFactory::Project],
    [:sub_project,  :"some_project",       ToFactory::Project],
    [:super_admin,  :admin,                ToFactory::User],
    [:"to_factory/user", nil,              ToFactory::User]


  to_infer = mappings.map{|a| a[0..1]}

  before do
    inference.setup to_infer
  end

  mappings.each do |klass, parent, expected|
    it "having #{klass} and #{parent.inspect} implies #{expected} "do
      result = inference.infer(klass)
      expect(result).to eq expected
    end
  end
end
