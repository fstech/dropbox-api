module Dropbox
  module API

    class Connection

      module Requests

        def request(options = {})
          response = yield
          raise Dropbox::API::Error::ConnectionFailed if !response
          status = response.code.to_i
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

        def method_missing(name, *args, &block)
          endpoint, path, data, headers = args[0], args[1], args[2], args[3]
          query = Dropbox::API::Util.query(data)
          case name
            when 'get_raw'
              request(:raw => true) do
                token(endpoint).get "#{Dropbox::API::Config.prefix}#{path}?#{URI.parse(URI.encode(query))}", headers
              end
            when 'get'
              request do
                token(endpoint).get "#{Dropbox::API::Config.prefix}#{path}?#{URI.parse(URI.encode(query))}", headers
              end
            when 'post'
              request do
                token(endpoint).post "#{Dropbox::API::Config.prefix}#{path}", data, headers
              end
            when 'put'
              request do
                token(endpoint).put "#{Dropbox::API::Config.prefix}#{path}", data, headers
              end
          end
        end
      end
    end
  end
end