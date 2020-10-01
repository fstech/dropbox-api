module Dropbox
  module API

    class Tasks

      extend Rake::DSL if defined? Rake::DSL

      def self.install

        namespace :dropbox do
          desc "Authorize wizard for Dropbox API"
          task :authorize do
            require "dropbox-api"
            require "cgi"
            print "Enter dropbox app key: "
            consumer_key = $stdin.gets.chomp
            print "Enter dropbox app secret: "
            consumer_secret = $stdin.gets.chomp

            Dropbox::API::Config.app_key    = consumer_key
            Dropbox::API::Config.app_secret = consumer_secret

            consumer = Dropbox::API::OAuth.consumer(:authorize)
            request_token = consumer.get_request_token
            puts "\nGo to this url and click 'Authorize' to get the token:"
            puts request_token.authorize_url
            query  = request_token.authorize_url.split('?').last
            params = CGI.parse(query)
            token  = params['oauth_token'].first
            print "\nOnce you authorize the app on Dropbox, press enter... "
            $stdin.gets.chomp

            access_token  = request_token.get_access_token(:oauth_verifier => token)

            puts "\nAuthorization complete!:\n\n"
            puts "  Dropbox::API::Config.app_key    = '#{consumer.key}'"
            puts "  Dropbox::API::Config.app_secret = '#{consumer.secret}'"
            puts "  client = Dropbox::API::Client.new(:token  => '#{access_token.token}', :secret => '#{access_token.secret}')"
            puts "\n"
          end

          desc "Authorize wizard for Dropbox API OAuth2"
          task :authorize_oauth2 do
            require "oauth2"
            require "dropbox-api"
            require "cgi"
            print "Enter dropbox app key: "
            consumer_key = $stdin.gets.chomp
            print "Enter dropbox app secret: "
            consumer_secret = $stdin.gets.chomp

            Dropbox::API::Config.app_key    = consumer_key
            Dropbox::API::Config.app_secret = consumer_secret

            auth_consumer = ::Dropbox::API::OAuth2.consumer(:authorize)
            authorize_uri = auth_consumer.authorize_url(client_id: Dropbox::API::Config.app_key, response_type: 'code')
            puts "\nGo to this url and click 'Authorize' to get the token:"
            puts authorize_uri
            print "\nOnce you authorize the app on Dropbox, paste the code here and press enter:"
            code = $stdin.gets.chomp

            main_consumer = ::Dropbox::API::OAuth2.consumer(:main)
            access_token = main_consumer.auth_code.get_token(code)
            puts "\nAuthorization complete!:\n\n"
            puts "  Dropbox::API::Config.app_key    = '#{consumer_key}'"
            puts "  Dropbox::API::Config.app_secret = '#{consumer_secret}'"
            puts "  client = Dropbox::API::Client.new(:token  => '#{access_token.token}')"
            puts "\n"
          end

        end

      end

    end

  end
end
