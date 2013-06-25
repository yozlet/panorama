require 'haml'
require 'sass'
require 'sinatra'
require 'sinatra/twitter-bootstrap'
require 'json'
require './panorama'

register Sinatra::Twitter::Bootstrap::Assets


get '/' do
  if request['dumpfile'] && request['dumpfile'] != ''
    roots = build_stack_from_file(request['dumpfile'])
  elsif request['codefile'] && request['codefile'] != ''
    codefile = request['codefile']
    code = File.read(codefile)
    panorama = Panorama.new
    panorama.start
    eval(code, nil, codefile, 1)
    panorama.stop
    puts panorama.invocations
    # remove the first four, since they're about require's work
    roots = build_stack(panorama.invocations)
  else
    roots = nil
  end

  haml :test, locals: {roots: roots}
end

get '/scss/:filename.scss' do
  scss :"scss/#{params[:filename]}", style: :expanded
end

def build_stack(inv_hashes)
  stack = []
  roots = []

  inv_hashes.each do |inv_hash|
    if inv_hash[:type] == 'call'
      inv = Invocation.new(inv_hash)
      if parent = stack.last
        parent.add_child inv
      else
        roots << inv
      end
      stack << inv
    elsif inv_hash[:type] == 'return'
      inv = stack.pop
      inv.finalise(inv_hash[:lineno], inv_hash[:val])
    elsif inv_hash[:type] == 'line'
      if inv = stack.last
        inv.add_line inv_hash
      end
    end
  end
  roots
end

def build_stack_from_file(filename)
  inv_hashes = File.open(filename).map do |l| 
    JSON.parse!(l)
    .inject({}) {|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
  build_stack inv_hashes
end


class Invocation
  @@id = 0

  attr_accessor :id, :method_name, :first_line, :last_line, :path, :args, :val, :children, :source


  def initialize(inv_hash)
    @id = new_id
    @method_name = inv_hash[:method_id]
    @first_line = inv_hash[:lineno]
    @path = inv_hash[:path]
    @args = inv_hash[:args]
    @children = []
    @line_locals = {}
  end

  def finalise(last_line, return_val)
    @last_line = last_line
    @source = get_source(@path, @first_line, @last_line)
    @val = return_val
  end

  def add_child(inv)
    @children << inv
  end

  def add_line(line)
    @line_locals[line[:lineno]] = line[:locals]
  end

  def json_line_locals
    JSON.dump @line_locals
  end

  def get_locals_for_line(lineno)
    @line_locals[lineno]
  end

  def json_args
    JSON.dump args
  end

  private

  def new_id
    @@id += 1
  end

  def get_source(path, first_line, last_line)
    File.open(path).to_a[first_line-1 .. last_line].join
  end

end