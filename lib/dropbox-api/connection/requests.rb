module Dropbox
  module API

    class Connection

      module Requests

        def request(options = {})
          response = yield
          raise Dropbox::API::Error::ConnectionFailed if !response
          status = (response.respond_to?(:code) ? response.code : response.status).to_i
          case status
            when 400
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error::BadInput.new("400 - Bad input parameter - #{parsed['error']}")
            when 401
              raise Dropbox::API::Error::Unauthorized.new("401 - Bad or expired token")
            when 403
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error::Forbidden.new('403 - Bad OAuth request')
            when 404
              raise Dropbox::API::Error::NotFound.new("404 - Not found")
            when 405
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error::WrongMethod.new("405 - Request method not expected - #{parsed['error']}")
            when 406
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error.new("#{status} - #{parsed['error']}")
            when 429
              raise Dropbox::API::Error::RateLimit.new('429 - Rate Limiting in affect')
            when 300..399
              raise Dropbox::API::Error::Redirect.new("#{status} - Redirect Error")
            when 503
              handle_503 response
            when 507
              raise Dropbox::API::Error::StorageQuota.new("507 - Dropbox storage quota exceeded.")
            when 500..502, 504..506, 508..599
              parsed = MultiJson.decode(response.body)
              raise Dropbox::API::Error.new("#{status} - Server error. Check http://status.dropbox.com/")
            else
              options[:raw] ? response.body : MultiJson.decode(response.body)
          end
        end

        def handle_503(response)
          if response.is_a? Net::HTTPServiceUnavailable
            raise Dropbox::API::Error.new("503 - #{response.message}")
          else
            parsed = MultiJson.decode(response.body)
            header_parse = MultiJson.decode(response.headers)
            error_message = "#{parsed["error"]}. Retry after: #{header_parse['Retry-After']}"
            raise Dropbox::API::Error.new("503 - #{error_message}")
          end
        end

        def get_raw(endpoint, path, data = {}, headers = {})
          query = Dropbox::API::Util.query(data)
          request_url = "#{Dropbox::API::Config.prefix}#{path}?#{URI.parse(URI.encode(query))}"
          request(:raw => true) do
            if token.is_a?(::OAuth2::AccessToken)
              token(endpoint).get request_url, :headers => headers, :raise_errors => false
            else
              token(endpoint).get request_url, headers
            end
          end
        end

        def get(endpoint, path, data = {}, headers = {})
          query = Dropbox::API::Util.query(data)
          request_url = "#{Dropbox::API::Config.prefix}#{path}?#{URI.parse(URI.encode(query))}"
          request do
            if token.is_a?(::OAuth2::AccessToken)
              token(endpoint).get request_url, :headers => headers, :raise_errors => false
            else
              token(endpoint).get request_url, headers
            end
          end
        end

        def post(endpoint, path, data = {}, headers = {})
          request_url = "#{Dropbox::API::Config.prefix}#{path}"
          request do
            if token.is_a?(::OAuth2::AccessToken)
              token(endpoint).post request_url, :body => data, :headers => headers, :raise_errors => false
            else
              token(endpoint).post request_url, data, headers
            end
          end
        end

        def put(endpoint, path, data = {}, headers = {})
          request_url = "#{Dropbox::API::Config.prefix}#{path}"
          request do
            if token.is_a?(::OAuth2::AccessToken)
              token(endpoint).put request_url, :body => data, :headers => headers, :raise_errors => false
            else
              token(endpoint).put request_url, data, headers
            end
          end
        end

      end

    end

  end
end
