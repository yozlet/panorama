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
    let(:trace_result) { described_class.new.trace(&code) }

    context 'when given empty code' do
      let(:code) { Proc.new {} }
      it 'returns an empty invocation set' do
        expect(trace_result).to eql([])
      end
    end

    context 'when given code with one invocation' do
      let(:code) { Proc.new { def foo; 12; end; foo(); } }
      let(:lineno) { __LINE__ - 1 } # number of the line above

      it 'returns an invocation set with one Invocation' do
        expect(trace_result).to have(1).item
        expect(trace_result[0]).to be_a Panorama::Invocation
      end

      describe 'which contains the correct attributes' do
        subject { trace_result[0] }

        its(:method_name)   { should eql :foo }
        its(:start_line)    { should eql lineno }
        its(:exit_line)     { should eql lineno }
        its(:path)          { should eql File.expand_path(__FILE__) }
        its(:return_value)  { should eql 12 }
      end
    end

  end

  describe '#trace_file' do
    let(:filepath) { File.absolute_path("spec/fixtures/#{filename}") }
    let(:trace_result) { described_class.new.trace_file(filepath) }

    context 'when given empty code' do
      let(:filename) { "empty.rb" }
      it 'returns an empty invocation set' do
        expect(trace_result).to eql([])
      end
    end

    context 'when given code with one invocation' do
      let(:filename) { "foo.rb" }
      let(:start_line) { 3 }
      let(:exit_line)  { 5 }

      it 'returns an invocation set with one Invocation' do
        expect(trace_result).to have(1).item
        expect(trace_result[0]).to be_a Panorama::Invocation
      end

      describe 'which contains the correct attributes' do
        subject { trace_result[0] }

        its(:method_name)   { should eql :foo }
        its(:start_line)    { should eql start_line }
        its(:exit_line)     { should eql exit_line }
        its(:path)          { should eql filepath }
        its(:return_value)  { should eql 12 }
      end
    end

    context 'when given code with a syntax error' do
    end

    context 'when given code with a runtime error' do
    end

    context "when pointed at a file that doesn't exist" do
    end

  end
end
