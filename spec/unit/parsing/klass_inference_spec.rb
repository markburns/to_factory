describe ToFactory::KlassInference do
  let(:inference) { ToFactory::KlassInference.new representations }

  mappings = [
    [:super_admin,  :admin,                ToFactory::User,    3],
    [:"to_factory/user", nil,              ToFactory::User,    1],
    [:admin,        :"to_factory/user",    ToFactory::User,    2],
    [:some_project, :"to_factory/project", ToFactory::Project, 2],
    [:sub_project,  :"some_project",       ToFactory::Project, 3],
  ]


  let(:representations) { mappings.map{|name, parent, _| ToFactory::Representation.new(name,parent) }}

  mappings.each do |name, parent_name, expected_klass, expected_order|
    it "having #{name} and #{parent_name.inspect} implies #{expected_klass} #{expected_order} "do
      result_klass, order = inference.infer(name.to_s)

      expect(result_klass).to eq expected_klass
      expect(order       ).to eq expected_order
    end
  end

  it do

    expect(lambda{inference.infer("unknown")}).to raise_error
  end
end
