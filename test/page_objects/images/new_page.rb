require 'page_objects/images/show_page'

module PageObjects
  module Images
    class NewPage < PageObjects::Document
      path :new_image
      path :images

      form_for :image do
        element :url
        element :tag_list
      end

      def create_image!(url_input: nil, tags: nil)
        url.set url_input if url_input
        tag_list.set tags if tags

        node.click_button('Save image URL')

        window.change_to(NewPage, ShowPage)
      end
    end
  end
end
