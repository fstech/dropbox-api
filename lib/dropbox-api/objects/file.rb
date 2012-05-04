module Dropbox
  module API

    class File < Dropbox::API::Object

      include Dropbox::API::Fileops

      def revisions(options = {})
        response = client.raw.revisions({ :path => self.path }.merge(options))
        Dropbox::API::Object.convert(response, client)
      end

      def restore(rev, options = {})
        response = client.raw.restore({ :rev => rev, :path => self.path }.merge(options))
        self.update response
      end

      def share_url(options = {})
        response = client.raw.shares({ :path => self.path }.merge(options))
        Dropbox::API::Object.init(response, client)
      end

      def direct_url(options = {})
        response = client.raw.media({ :path => self.path }.merge(options))
        Dropbox::API::Object.init(response, client)
      end

      def thumbnail(options = {})
        client.raw.thumbnails({ :path => self.path }.merge(options))
      end
      
      def copy_ref(options = {})
        response = client.raw.copy_ref({ :path => self.path }.merge(options))
        Dropbox::API::Object.init(response, client)
      end
      
      def download
        client.download(self.path)
      end

    end

  end
end
