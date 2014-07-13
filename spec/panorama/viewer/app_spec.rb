ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require 'panorama/viewer/app.rb'
require 'open3'

describe Panorama::Viewer do
  include Rack::Test::Methods

  def app
    Panorama::Viewer
  end
  
  Capybara.app = Panorama::Viewer
  
  let(:codepath)   { File.absolute_path("spec/fixtures/simple/three_functions.rb") }
  let(:call_count) { 1 }

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match('Hello World!')
  end

  describe "debugs named files" do
    it "when passed in through app settings" do
      Capybara.app.settings.codepath = codepath
      @home = HomePage.new
      @home.load
      expect(@home.codepath.text).to match(codepath)
      Capybara.app.settings.codepath = nil
    end
    
    it "when passed in through a query string argument" do
      @home = HomePage.new
      @home.load(query: {codepath: codepath})
      expect(@home.codepath.text).to match(codepath)
    end
  end

  describe "prints debug stats" do
    subject do
      @home = HomePage.new
      @home.load(query: {codepath: codepath})
      @home.stats
    end
    it "with correct call count" do
      expect(subject.call_count.text).to eql "3"
    end
  end

  it 'can be run from the command line' do
    # pending "Doesn't work on Codio, apparently?"
    arg = codepath
    exe = 'ruby'
    appfile = File.expand_path('../../lib/panorama/viewer/app.rb', File.dirname(__FILE__))
    Open3.popen3("#{exe} #{appfile} #{arg}") do |stdin, stdout, stderr, wait_thr|
      stdin.close
      while line = stderr.gets
        if line =~ /start/
          break
        end
      end
    end
  end

end