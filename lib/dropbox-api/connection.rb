require "dropbox-api/connection/requests"

module Dropbox
  module API

    class Connection

      include Dropbox::API::Connection::Requests

      attr_accessor :consumers
      attr_accessor :tokens

      def initialize(options = {})
        @options   = options
        @consumers = {}
        @tokens    = {}
        Dropbox::API::Config.endpoints.each do |endpoint, url|
          auth_class = Dropbox::API::Config.auth_type == 'oauth2' ? Dropbox::API::OAuth2 : Dropbox::API::OAuth
          @consumers[endpoint] = auth_class.consumer(endpoint)
          @tokens[endpoint]    = auth_class.access_token(@consumers[endpoint], options)
        end
      end

      def consumer(endpoint = :main)
        @consumers[endpoint]
      end

      def token(endpoint = :main)
        @tokens[endpoint]
      end

    end

  end
end
