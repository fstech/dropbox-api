require "spec_helper"

describe Dropbox::API::Dir, :vcr => true do

  before do
    @client = Dropbox::Spec.instance
    @dirname = "dir-spec-tests"
    @dir = @client.mkdir @dirname
  end

  describe "#copy" do

    it "copies the dir properly" do
      new_dirname = @dirname + "-copied"
      @dir.copy new_dirname
      @dir.path.should == new_dirname
    end

  end

  describe "#move" do

    it "moves the dir properly" do
      new_dirname = @dirname + "-copied"
      @dir.move new_dirname
      @dir.path.should == new_dirname
    end

  end

  describe "#destroy" do

    it "destroys the dir properly" do
      @dir.destroy
      @dir.is_deleted.should == true
    end

  end

  describe "#direct_url" do

    it "gives the direct url" do
      direct_url_object = @dir.direct_url
      direct_url_object.url.should eql 'https://www.dropbox.com/sh/y2wx4tpk9co1uqg/7wFKjUC2ep'
      direct_url_object.expires.should eql 'Tue, 01 Jan 2030 00:00:00 +0000'
    end

  end

end
