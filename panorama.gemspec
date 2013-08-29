$:.push File.expand_path("../lib", __FILE__)
require "panorama/version"

Gem::Specification.new do |s|
  s.name = "panorama"
  s.version = Panorama::VERSION
  s.authors = [ "Yoz Grahame" ]
  s.email = "yoz@yoz.com"
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = '>= 2.0'
  s.files = `git ls-files`.split("\n")
  s.require_paths = [ "lib" ]
  s.homepage = "http://yozlet.github.com/panorama"
  s.licenses = [ "MIT" ]
  s.summary = "A Visual Debugger for Ruby"

  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'guard-rspec'
end
