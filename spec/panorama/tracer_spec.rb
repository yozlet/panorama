require 'spec_helper'

describe Panorama::Tracer do

  it 'can be instantiated' do
    expect(described_class.new).to be_a(described_class)
  end

end