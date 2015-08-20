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

  s.add_dependency 'sinatra'
  s.add_dependency 'haml'
  s.add_dependency 'sass'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.0'
  s.add_development_dependency 'rspec-its'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'site_prism'
end
