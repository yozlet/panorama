require 'spec_helper'

describe Panorama::Invocation do
  describe '#source_lines' do
    let(:filepath) { File.absolute_path("spec/fixtures/#{filename}") }
    let(:trace_results) { Panorama::Tracer.new.trace_file(filepath) }
    let(:invocation_set) { trace_results[:invocations] }
    let(:filename) { 'simple/three_functions.rb' }

    it 'returns the source code of an invocation' do
      expected_source = [
        "def foo\n",
        "  x = 4\n",
        "  bar(x)\n",
        "  3 * x\n",
        "end\n"
      ]
      expect(invocation_set[0].source_lines).to eql expected_source
    end
  end
end
