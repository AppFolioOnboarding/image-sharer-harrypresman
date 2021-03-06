require 'page_objects/images/image_card'
require 'page_objects/images/show_page'
require 'page_objects/images/new_page'

module PageObjects
  module Images
    class IndexPage < PageObjects::Document
      path :images

      collection :images, locator: '#js-found-images', item_locator: '.image', contains: ImageCard do
        def view!
          element(locator: '.js-image-link').node.click
          stale!
          window.change_to(ShowPage)
        end
      end

      def add_new_image!
        element(locator: '.js-create-image').node.click
        stale!
        window.change_to(NewPage)
      end

      def showing_image?(url:, tags: nil)
        images.any? do |image|
          image.url == url && (tags ? image.tags == tags : true)
        end
      end

      def click_tags!(tag_names)
        tag_names.each do |tag_name|
          node.find("option[value=#{tag_name}]").click
        end
        element(locator: '#js-filter-images').node.click
        stale!
        window.change_to(IndexPage)
      end

      def clear_tag_filter!
        element(locator: '#js-filter-images').node.click
        stale!
        window.change_to(IndexPage)
      end
    end
  end
end
