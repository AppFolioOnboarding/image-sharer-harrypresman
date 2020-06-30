class Image < ApplicationRecord
  acts_as_taggable_on :tags

  validates :url, presence: true, url: { allow_blank: true }
end
