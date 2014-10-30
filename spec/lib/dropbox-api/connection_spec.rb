require "spec_helper"

describe Dropbox::API::Connection do

  before do
    @connection = Dropbox::API::Connection.new(:token  => Dropbox::Spec.token,
                                               :secret => Dropbox::Spec.secret)
  end

  describe "#request" do

    it "returns a parsed response when the response is a 200" do
      response = double :code => 200, :body => '{ "a":1}'
      response = @connection.request { response }
      response.should be_an_instance_of(Hash)
    end

    it "raises a Dropbox::API::Error::Unauthorized when the response is a 401" do
      response = double :code => 401, :body => '{ "a":1}'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::Unauthorized, '401 - Bad or expired token')
    end

    it "raises a Dropbox::API::Error::Forbidden when the response is a 403" do
      response = double :code => 403, :body => '{ "a":1}'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::Forbidden, '403 - Bad OAuth request')
    end

    it "raises a Dropbox::API::Error::NotFound when the response is a 404" do
      response = double :code => 404, :body => '{ "a":1}'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::NotFound, '404 - Not found')
    end

    it "raises a Dropbox::API::Error::WrongMethod when the response is a 405" do
      response = double :code => 405, :body => '{ "error": "The requested method GET is not allowed for the URL /foo/." }'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::WrongMethod, '405 - Request method not expected - The requested method GET is not allowed for the URL /foo/.')
    end

    it "raises a Dropbox::API::Error when the response is a 3xx" do
      response = double :code => 301, :body => '{ "a":1}'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::Redirect, '301 - Redirect Error')
    end

    it "raises a Dropbox::API::Error when the response is a 5xx" do
      response = double :code => 500, :body => '{ "a":1}'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error, '500 - Server error. Check http://status.dropbox.com/')
    end

    it "raises a Dropbox::API::Error when the response is a 400" do
      response = double :code => 400, :body => '{ "error": "bad request foo" }'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::BadInput, '400 - Bad input parameter - bad request foo')
    end

    it "raises a Dropbox::API::Error when the response is a 406" do
      response = double :code => 406, :body => '{ "error": "bad request bar" }'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error, '406 - bad request bar')
    end

    it "raises a Dropbox::API::Error when the response is a 429" do
      response = double :code => 429, :body => '{ "error": "rate limited" }'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error::RateLimit, '429 - Rate Limiting in affect')
    end

    it "raises a Dropbox::API::Error when the response is a 503" do
      response = double :code => 503, :body => '{ "error": "rate limited" }', :headers => '{ "Retry-After": "50" }'
      lambda do
       @connection.request { response }
     end.should raise_error(Dropbox::API::Error, '503 - rate limited. Retry after: 50')
   end

    it "raises a Dropbox::API::Error::StorageQuota when the response is a 507" do
      response = double :code => 507, :body => '{ "error": "quote limit" }'
      lambda do
        @connection.request { response }
      end.should raise_error(Dropbox::API::Error, '507 - Dropbox storage quota exceeded.')
    end


    it "returns the raw response if :raw => true is provided" do
      response = double :code => 200, :body => '{ "something": "more" }'
      response = @connection.request(:raw => true) { response }
      response.should == '{ "something": "more" }'
    end

  end

  describe "#consumer" do

    it "returns an appropriate consumer object" do
      @connection.consumer(:main).should be_a(::OAuth::Consumer)
    end

  end

  describe "errors" do

    it "recovers error with rescue statement modifier" do
      expect { raise Dropbox::API::Error rescue nil }.to_not raise_error
    end

    it "recovers any kind of errors with the generic error" do
      expect do
        begin
          raise Dropbox::API::Error::Forbidden
        rescue Dropbox::API::Error
        end
      end.to_not raise_error
    end

  end

end
