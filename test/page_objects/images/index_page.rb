module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '#js-found-images', item_locator: '.image', contains: ImageCard do
        def view!
          # TODO
        end
      end

      def add_new_image!
        element(locator: '.js-create-image').node.click
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        images.any? do |image|
          image.url == url && (tags ? image.tags == tags : true)
        end
      end

      def clear_tag_filter!
        # TODO
      end
    end
  end
end
