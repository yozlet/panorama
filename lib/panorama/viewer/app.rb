$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
require 'sinatra'
require 'panorama'
require 'haml'

module Panorama
  class Viewer < Sinatra::Base

    set :codepath, nil
    set :bind, '0.0.0.0'
    
    get '/' do 
      @codepath = request['codepath'] || settings.codepath
      if @codepath
        @trace = Panorama::Tracer.new.trace_file(@codepath)
        @call_count = @trace.size
      end
      haml :index
    end

    # start the server if ruby file executed directly
    if app_file == $0
      set :codepath, $1
      run!
    end

  end
end