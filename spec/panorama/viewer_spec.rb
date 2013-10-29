ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require 'panorama/viewer/app.rb'
require 'Open3'

describe Panorama::Viewer do
  include Rack::Test::Methods

  def app
    Panorama::Viewer
  end

  let(:code_path) { "../spec/fixtures/hello.rb" }

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match('Hello World!')
  end

  it 'can be run from the command line' do
    pending
    arg = code_path
    exe = 'ruby'
    appfile = File.expand_path('../../lib/panorama/viewer/app.rb', File.dirname(__FILE__))
    Open3.popen3("#{exe} #{appfile} #{arg}") do |stdin, stdout, stderr, wait_thr|
      stdin.close
      while line = stderr.gets
        puts line
        if line =~ /start/
          break
        end
      end
    end
  end

  it "accepts a path to a ruby file to run" do
    app.settings.code_path = code_path
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to match(code_path)
  end
end