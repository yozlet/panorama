require 'spec_helper'

describe Panorama::Tracer do
  it 'can be instantiated' do
    expect(described_class.new).to be_a described_class
  end

  describe '#trace' do
    let(:trace_results) { described_class.new.trace(&code) }
    let(:invocation_set) { trace_results[:invocations] }
    let(:root_set) { trace_results[:roots] }

    context 'when given empty code' do
      let(:code) { proc {} }
      it 'returns an empty invocation set' do
        expect(invocation_set).to eql([])
      end
      it 'returns an empty root set' do
        expect(root_set).to eql([])
      end
    end

    context 'when given code with one invocation' do
      let(:code) { proc { def foo; 12; end; foo } }
      let(:lineno) { __LINE__ - 1 } # number of the line above

      it 'returns an invocation set with one Invocation' do
        expect(invocation_set).to have(1).item
        expect(invocation_set[0]).to be_a Panorama::Invocation
      end

      describe 'which contains the correct attributes' do
        subject { invocation_set[0] }

        its(:method_name)   { should eql :foo }
        its(:start_line)    { should eql lineno }
        its(:exit_line)     { should eql lineno }
        its(:path)          { should eql File.expand_path(__FILE__) }
        its(:children)      { should eql [] }
        its(:return_value)  { should eql 12 }
      end
    end

  end

  describe '#trace_file' do
    let(:filepath) { File.absolute_path("spec/fixtures/#{filename}") }
    let(:trace_results) { described_class.new.trace_file(filepath) }
    let(:invocation_set) { trace_results[:invocations] }
    let(:root_set) { trace_results[:roots] }

    context 'when given empty code' do
      let(:filename) { 'empty.rb' }
      it 'returns an empty invocation set' do
        expect(invocation_set).to eql([])
      end
      it 'returns an empty root set' do
        expect(root_set).to eql([])
      end
    end

    context 'when given code with one invocation' do
      let(:filename) { 'simple/one_function.rb' }
      let(:start_line) { 3 }
      let(:exit_line)  { 5 }

      it 'returns an invocation set with one Invocation' do
        expect(invocation_set).to have(1).item
        expect(invocation_set[0]).to be_a Panorama::Invocation
      end

      describe 'which contains the correct attributes' do
        subject { invocation_set[0] }

        its(:method_name)   { should eql :foo }
        its(:start_line)    { should eql start_line }
        its(:exit_line)     { should eql exit_line }
        its(:path)          { should eql filepath }
        its(:children)      { should eql [] }
        its(:return_value)  { should eql 12 }
      end

      it 'and is also in the root set' do
        expect(invocation_set[0]).to eql root_set[0]
      end
    end

    context 'when given code with chained invocations' do
      let(:filename) { 'simple/three_functions.rb' }

      it 'returns a root set with one Invocation' do
        expect(root_set).to have(1).item
        expect(root_set[0]).to be_a Panorama::Invocation
      end

      describe 'which has a child with the next Invocation' do
        subject { root_set[0] }

        its(:method_name)   { should eql :foo }
        its(:children)      { should have(1).item }
      end

      describe 'which also has a child with the next Invocation' do
        subject { root_set[0].children[0] }

        its(:method_name)   { should eql :bar }
        its(:children)      { should have(1).item }
      end

      describe 'which has the correct attributes' do
        subject { root_set[0].children[0].children[0] }

        its(:method_name)   { should eql :baz }
        its(:children)      { should eql [] }
      end

      it 'and all three invocations are in the invocation set' do
        expect(invocation_set[0]).to eql root_set[0]
        expect(invocation_set[1]).to eql root_set[0].children[0]
        expect(invocation_set[2]).to eql root_set[0].children[0].children[0]
      end
    end

    context 'when given code with a syntax error' do
      let(:filename) { 'simple/syntax_error.rb' }

      it 'returns an invocation set with one SyntaxError' do
        expect(invocation_set).to have(1).item
        expect(invocation_set[0]).to be_a SyntaxError
      end
    end

    context 'when given code with a runtime error' do
      let(:filename) { 'simple/runtime_error.rb' }

      describe 'returns an invocation set' do
        it 'contains two items' do
          expect(invocation_set).to have(2).items
        end

        it 'contains an Invocation' do
          expect(invocation_set[0]).to be_a Panorama::Invocation
        end

        it 'contains a RuntimeError' do
          expect(invocation_set[1]).to be_a RuntimeError
          # Actually this should be another custom event record created
          # by a :raise TP event
          # TODO: have Invocation, Raise etc. descend from an Event class
        end
      end
    end

    context "when pointed at a file that doesn't exist" do
      pending
    end

  end
end
