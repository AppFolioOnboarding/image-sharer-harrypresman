require 'test_helper'

class ImageTest < ActiveSupport::TestCase
  test 'validating image with nil url fails with blank error message' do
    image = Image.new(url: nil)
    refute_predicate image, :valid?
    assert_equal ["can't be blank"], image.errors[:url]
  end

  test 'validating image with invalid url fails with valid URL message' do
    image = Image.new(url: 'not_a_real_url')
    refute_predicate image, :valid?
    assert_equal ['is not a valid URL'], image.errors[:url]
  end

  test 'validating image with valid url succeeds' do
    image = Image.new(url: 'https://www.imgur.com')
    assert_predicate image, :valid?
    assert_empty image.errors[:url]
  end
end