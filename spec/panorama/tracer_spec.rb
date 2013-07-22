require 'spec_helper'

describe Panorama::Tracer do

  it 'can be instantiated' do
    expect(described_class.new).to be_a Panorama::Tracer
  end

  describe "state" do
    let(:tracer) { Panorama::Tracer.new }

    it 'starts in an inactive state' do
      expect(tracer).to_not be_active
    end

    it 'can be started' do
      tracer.start
      expect(tracer).to be_active
    end

    it 'can be stopped' do
      tracer.start
      tracer.stop
      expect(tracer).to_not be_active
    end

  end

end