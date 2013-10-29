require 'sinatra'

module Panorama
  class Viewer < Sinatra::Base

    set :code_path, nil

    get '/' do 
      "Hello World! Code path is #{settings.code_path}"
    end

    # start the server if ruby file executed directly
    if app_file == $0
      set :code_path, $1
      run!
    end

  end
end
