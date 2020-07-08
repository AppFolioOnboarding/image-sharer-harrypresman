require 'page_objects/images/show_page'

module PageObjects
  module Images
    class EditPage < PageObjects::Document
      path :edit_image
      path :image

      form_for :image do
        element :tag_list, locator: '#js-tag-list-input'
      end

      def edit_tags!(tags: [])
        tag_list.set fixup(tags)

        node.click_button('Save new image tags')

        # Both pages match due to the :image path, so the only way to disambiguate is to inspect the page.
        # The change_to API allows selection by block or title as well, but that only works with a single
        # document, so the if/else seems to be a more readable solution.
        if document.element(locator: '#js-edit-image-button').present?
          window.change_to(ShowPage)
        else
          window.change_to(EditPage)
        end
      end

      def tags?(tags)
        tag_list.value == fixup(tags)
      end

      private

      def fixup(tags)
        tags.join(', ')
      end
    end
  end
end
