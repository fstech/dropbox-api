$:.push File.expand_path("../../lib", __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end
require 'dropbox-api'
require 'rspec'

module Dropbox
  Spec = Hashie::Mash.new
end

Dir.glob("#{File.dirname(__FILE__)}/support/*.rb").each { |f| require f }