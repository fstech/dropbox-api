# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dropbox-api/version"

Gem::Specification.new do |s|
  s.name        = "dropbox-api"
  s.version     = Dropbox::API::VERSION
  s.authors     = ["Marcin Bunsch"]
  s.email       = ["marcin@futuresimple.com"]
  s.homepage    = "http://github.com/futuresimple/dropbox-api"
  s.summary     = "A Ruby client for the Dropbox REST API."
  s.description = "To deliver a more Rubyesque experience when using the Dropbox API."
  s.license     = 'MIT'

  s.rubyforge_project = "dropbox-api"

  s.add_dependency 'multi_json', '~> 1.7.9'
  s.add_dependency 'oauth', '~> 0.4.7'
  s.add_dependency 'hashie', '~> 2.0.5'

  s.add_development_dependency 'rspec','2.14.1'
  s.add_development_dependency 'rake', '10.1.0'
  s.add_development_dependency 'simplecov', '~> 0.8.2'
  s.add_development_dependency 'yajl-ruby', '~> 1.2.0'

  s.add_development_dependency 'webmock', '~> 1.15.0'
  s.add_development_dependency 'vcr', '~> 2.8.0'

  if RUBY_VERSION < "1.9"
    s.add_development_dependency 'ruby-debug19'
  end

end
