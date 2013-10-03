require 'sinatra'

module Panorama
  class Viewer < Sinatra::Base

    get '/' do 
      'Hello World!'
    end

  end
end
