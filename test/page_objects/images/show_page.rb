require 'page_objects/images/index_page'
require 'page_objects/images/edit_page'

module PageObjects
  module Images
    class ShowPage < PageObjects::Document
      path :image

      def image_url
        element(locator: :img).node[:src]
      end

      def tags
        element(locator: '.js-tag-list-text').node.text.gsub(/\s+/, '').split(',')
      end

      def edit!
        node.click_button('Edit image tags')
        stale!
        window.change_to(EditPage)
      end

      def delete
        element(locator: '#js-delete-image-button').node.click
        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!
        delete(&:accept)
        stale!
        window.change_to(IndexPage)
      end

      def go_back_to_index!
        IndexPage.visit
      end
    end
  end
end
