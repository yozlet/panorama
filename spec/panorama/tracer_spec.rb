require 'spec_helper'

describe Panorama::Tracer do
  it 'can be instantiated' do
    expect(described_class.new).to be_a Panorama::Tracer
  end

  describe 'state' do

    it 'starts in an inactive state' do
      expect(subject).to_not be_active
    end

    it 'can be started' do
      subject.start
      expect(subject).to be_active
    end

    it 'can be stopped' do
      subject.start
      subject.stop
      expect(subject).to_not be_active
    end
  end

  describe '#trace' do

    context 'when given empty code' do
      it 'returns an empty invocation set' do
        expect(subject.trace{}).to eql([])
      end
    end

    context 'when given code with one invocation' do
      let(:code) { Proc.new { def foo; true; end; foo(); } }

      it 'returns an invocation set with one Invocation' do
        expect(subject.trace(&code)).to have(1).item
        expect(subject.trace(&code)[0]).to be_a Panorama::Invocation
      end

      it 'returns an Invocation with the name, line number and file path of the method' do
        expect(subject.trace(&code)[0].method_name).to eql(:foo)
        expect(subject.trace(&code)[0].lineno).to eql(35)
        expect(subject.trace(&code)[0].path).to eql(File.expand_path(__FILE__))
      end
    end

  end

end