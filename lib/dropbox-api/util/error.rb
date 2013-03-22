module Dropbox
  module API

    class Error < StandardError

      class ConnectionFailed < Error; end
      class Config < Error; end
      class Unauthorized < Error; end
      class Forbidden < Error; end
      class NotFound < Error; end
      class Redirect < Error; end

    end

  end
end
