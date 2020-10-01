module Dropbox
  module API

    module OAuth2

      class << self

        def consumer(endpoint)
          if !Dropbox::API::Config.app_key or !Dropbox::API::Config.app_secret
            raise Dropbox::API::Error::Config.new("app_key or app_secret not provided")
          end
          ::OAuth2::Client.new(Dropbox::API::Config.app_key, Dropbox::API::Config.app_secret,
            :site               => Dropbox::API::Config.endpoints[endpoint],
            :authorize_url      => "#{Dropbox::API::Config.prefix}/oauth2/authorize",
            :token_url          => "#{Dropbox::API::Config.prefix}/oauth2/token")
        end

        def access_token(konsumer, options = {})
          ::OAuth2::AccessToken.new(konsumer, options[:token], options)
        end

      end

    end

  end
end

