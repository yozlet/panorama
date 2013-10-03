ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'
require 'panorama/viewer/app.rb'

describe Panorama::Viewer do
  include Rack::Test::Methods

  def app
    Panorama::Viewer
  end

  it "says hello" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eql('Hello World!')
  end
end