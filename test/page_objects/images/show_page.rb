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

      def delete
        # TODO
        yield node.driver.browser.switch_to.alert
      end

      def delete_and_confirm!
        # TODO
        window.change_to(IndexPage)
      end

      def go_back_to_index!
        IndexPage.visit
      end
    end
  end
end
