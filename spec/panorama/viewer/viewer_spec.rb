ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require 'panorama/viewer/viewer.rb'
require 'open3'

describe Panorama::Viewer do
  include Rack::Test::Methods

  def app
    Panorama::Viewer
  end

  Capybara.app = described_class

  let(:codepath) {
    File.absolute_path('spec/fixtures/simple/three_functions.rb')
  }
  let(:code_invocations) do [
    {
      method_name: 'foo',
      path: codepath,
      start_line: '2',
      exit_line: '6',
      return_value: '12'
    },
    {
      method_name: 'bar',
      path: codepath,
      start_line: '8',
      exit_line: '10',
      return_value: '6'
    },
    {
      method_name: 'baz',
      path: codepath,
      start_line: '12',
      exit_line: '14',
      return_value: '6'
    }
  ]
  end

  describe 'debugs named files' do
    it 'when passed in through app settings' do
      Capybara.app.settings.codepath = codepath
      home = HomePage.new
      home.load
      expect(home.codepath.text).to match(codepath)
      Capybara.app.settings.codepath = nil
    end

    it 'when passed in through a query string argument' do
      home = HomePage.new
      home.load(query: { codepath: codepath })
      expect(home.codepath.text).to match(codepath)
    end
  end

  describe 'prints debug stats' do
    subject do
      home = HomePage.new
      home.load(query: { codepath: codepath })
      home.stats
    end
    it 'with correct call count' do
      expect(subject.call_count.text).to eql code_invocations.length.to_s
    end
  end

  describe 'prints invoked functions' do
    subject do
      home = HomePage.new
      home.load(query: { codepath: codepath })
      home.invocations
    end
    it 'with correct details' do
      invocations = subject.map do |section|
        invocation = {}
        code_invocations[0].each_key do |k|
          invocation[k] = section.send(k).text
        end
        invocation
      end
      expect(invocations).to eql code_invocations
    end
  end

  it 'can be run from the command line' do
    arg = codepath
    exe = 'ruby'
    appfile = File.expand_path('../../lib/panorama/viewer/app.rb',
                               File.dirname(__FILE__))
    Open3.popen3("#{exe} #{appfile} #{arg}") do |stdin, _, stderr, _|
      stdin.close
      loop do
        line = stderr.gets
        break if line =~ /start/ || !line
      end
    end
  end
end
