module PageObjects
  module Images
    class ImageCard < AePageObjects::Element
      def url
        node.find('img')[:src]
      end

      def tags
        element(locator: '.js-tag-list-text').node.text.gsub(/\s+/, '').split(',')
      end
    end
  end
end
