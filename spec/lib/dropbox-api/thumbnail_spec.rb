require "spec_helper"
require "fileutils"

describe Dropbox::API::File, vcr: true do

  before do
    @io       = StringIO.new
    @client   = Dropbox::Spec.instance
    @jpeg      = File.read("spec/fixtures/dropbox.jpg")
  end

  describe "#thumbnail" do

    it "downloads a thumbnail" do
      @filename = "spec-test-1392058752.jpg"
      @file     = @client.upload @filename, @jpeg
      result = @file.thumbnail

      @io << result
      @io.rewind

      jpeg = JPEG.new(@io)
      jpeg.height.should == 64
      jpeg.width.should == 64
    end

  end

end
