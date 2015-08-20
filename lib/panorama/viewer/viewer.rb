$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))
require 'sinatra'
require 'panorama'
require 'haml'
require 'sass'


module Panorama
  class Viewer < Sinatra::Application
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

    get '/scss/:filename.scss' do
      scss :"scss/#{params[:filename]}", style: :expanded
    end

    # start the server if ruby file executed directly
    if app_file == $PROGRAM_NAME
      set :codepath, ARGV[1]
      run!
    end

  end
end
