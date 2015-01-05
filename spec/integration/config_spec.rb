describe "ToFactory  Configuration" do
  before do
    ToFactory.reset_config!
  end

  it do
    expect(ToFactory.factories).to eq "./spec/factories"
    ToFactory.factories = "factories dir"

    expect(ToFactory.factories).to eq "factories dir"
  end

  it do
    expect(ToFactory.models).to eq "./app/models"
    ToFactory.models = "models dir"

    expect(ToFactory.models).to eq "models dir"
  end
end
