require 'spec_helper'

describe Generator do
  let(:gen) {Generator.new}

  it "reads the exisiting journal file" do
    expect(gen.file.class).to eq(Pathname)
  end

  it "reads the config file YAML as Hash" do
    expect(gen.read_config.class).to eq(Hash)
  end

  it "knows the date of the last updated" do
    expect(gen.last_updated.class).to eq(Date)
  end

  it "sets new entries' date to :last_update + 1" do
    expect(gen.last_updated+1).to eq(Date.today)
  end
end
