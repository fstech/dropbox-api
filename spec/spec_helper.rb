$:.push File.expand_path("../../lib", __FILE__)

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end
require 'dropbox-api'
require 'rspec'
require 'webmock/rspec'
require 'vcr'

module Dropbox
  Spec = Hashie::Mash.new
end

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.cassette_library_dir = 'spec/vcr/cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end


Dir.glob("#{File.dirname(__FILE__)}/support/*.rb").each { |f| require f }

# Clean up after specs, remove test-directory
RSpec.configure do |config|
  config.after(:all) do
    test_dir = Dropbox::Spec.instance.find(Dropbox::Spec.test_dir) rescue nil
    test_dir.destroy if test_dir and !test_dir.is_deleted?
  end
end

