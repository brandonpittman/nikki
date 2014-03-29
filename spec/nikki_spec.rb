require 'spec_helper'

describe Generator do
  let(:gen) {Generator.new}

  it "reads the existing journal file YAML as Hash" do
    expect(gen.read_file.class).to eq(Hash)
  end

  it "reads the exisiting journal file" do
    expect(gen.file.class).to eq(Pathname)
  end

  it "reads the config file YAML as Hash" do
    expect(gen.read_config.class).to eq(Hash)
  end
end
