class Image < ApplicationRecord
  validates :url, presence: true, url: { allow_blank: true }
end
