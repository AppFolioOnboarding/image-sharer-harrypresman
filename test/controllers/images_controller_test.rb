require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest # rubocop:disable Metrics/ClassLength
  # root

  test 'index page renders images in descending order' do
    Image.create!([{ url: 'http://someurl', created_at: 1 }, { url: 'http://someurl2', created_at: 0 }])

    get images_path

    assert_response :ok

    assert_select '.image' do |image_divs|
      assert_select image_divs.first, 'img' do |imgs|
        assert_equal 'http://someurl2', imgs.first[:src]
      end
      assert_select image_divs.last, 'img' do |imgs|
        assert_equal 'http://someurl', imgs.first[:src]
      end
    end
  end

  test 'index page filters images based on tag' do
    Image.create!([{ url: 'http://someurl', tag_list: %w[a b c] },
                   { url: 'http://someurl2', tag_list: %w[c] }])

    get images_path, params: { tag: %w[a b] }

    assert_response :ok

    assert_select '.image' do
      assert_select('img') { |images| assert_equal 1, images.count }
      assert_select 'img[src=?]', 'http://someurl'
    end
  end

  test 'index page filters images based on any matching tag' do
    Image.create!([{ url: 'http://someurl', tag_list: %w[a c] },
                   { url: 'http://someurl2', tag_list: %w[c] },
                   { url: 'http://someurl3', tag_list: %w[b c] }])

    get images_path, params: { tag: %w[a b] }

    assert_response :ok

    assert_select '.image' do
      assert_select('img') { |images| assert_equal 2, images.count }
      assert_select 'img[src=?]', 'http://someurl'
      assert_select 'img[src=?]', 'http://someurl3'
    end
  end

  test 'index page should show empty image div if no images match tags' do
    Image.create!([{ url: 'http://someurl' }])

    get images_path, params: { tag: %w[a] }

    assert_response :ok

    assert_select '.empty_images'
    assert_select '.image', false
  end

  # images GET

  test 'get images is success' do
    get images_path

    assert_response :ok
  end

  test 'images page should show create images link' do
    get images_path

    assert_response :ok

    assert_select 'a' do |a_tags|
      assert_equal 1, a_tags.length
      assert_equal new_image_path, a_tags.first[:href]
    end
  end

  test 'images page should show tag selector with tags' do
    Image.create!([{ url: 'http://someurl', tag_list: %w[a b] }])

    get images_path

    assert_response :ok

    assert_select '#js-filter-images-form' do
      assert_select 'select'
      assert_select 'option[value=a]'
      assert_select 'option[value=b]'
      assert_select '#js-filter-images'
    end
  end

  test 'images page should show tag selector with tags from all images' do
    Image.create!([{ url: 'http://someurl', tag_list: %w[a] }, { url: 'http://someurl2', tag_list: %w[b] }])

    get images_path

    assert_response :ok

    assert_select '#js-filter-images-form' do
      assert_select 'select'
      assert_select 'option[value=a]'
      assert_select 'option[value=b]'
      assert_select '#js-filter-images'
    end
  end

  test 'images page should display saved images' do
    Image.create!([{ url: 'http://someurl' }, { url: 'http://someurl2' }])
    get images_path

    assert_response :ok

    assert_select('.image') { |images| assert_equal 2, images.count }
  end

  # images POST

  test 'creating an image should save image' do
    assert_difference 'Image.count' do
      post images_path image: { url: 'http://someurl' }
    end
    assert_response :found
    assert_equal 'http://someurl', Image.last.url
  end

  test 'creating an image with image tags should save image' do
    assert_difference 'Image.count' do
      post images_path image: { url: 'http://someurl', tag_list: 'a, b, c' }
    end
    assert_response :found
    assert_equal %w[a b c], Image.last.tag_list
  end

  test 'creating an image should redirect to image page' do
    post images_path image: { url: 'http://someurl' }

    assert_response :found
    assert_redirected_to image_path Image.last
  end

  test 'on failing to create an image, the page is re-rendered' do
    assert_no_difference 'Image.count' do
      post images_path image: { url: '' }
    end
    assert_nil Image.last
    assert_response :ok
  end

  test 'posting image with invalid url keeps user URL as value' do
    post images_path image: { url: 'bad url' }
    assert_response :ok

    assert_select '.url_input[value=?]', 'bad url'
  end

  test 'posting image with invalid url keeps user tags as value' do
    post images_path image: { url: 'bad url', tag_list: 'a, b, c' }
    assert_response :ok

    assert_select '.tag_list_input[value=?]', 'a, b, c'
  end

  # images/:id

  test 'displaying an image is success' do
    image = Image.create!(url: 'http://someurl')
    get image_path image

    assert_response :ok
  end

  test 'image page contains back link' do
    image = Image.create!(url: 'http://someurl')
    get image_path image

    assert_response :ok

    assert_select 'a' do |anchors|
      assert_equal images_path, anchors.first[:href]
    end
  end

  test 'image page contains delete button with confirmation dialog' do
    image = Image.create!(url: 'http://someurl')
    get image_path image

    assert_response :ok

    assert_select '.button_to' do
      assert_select 'input[type=submit]'
      assert_select 'input[data-confirm]'
    end
  end

  test 'displaying an image should show image data' do
    image = Image.create!(url: 'http://someurl')
    get image_path image

    assert_response :ok

    assert_select 'img' do |images|
      assert_equal 'http://someurl', images.first[:src]
    end
  end

  test 'displaying an image should show tag data' do
    image = Image.create!(url: 'http://someurl', tag_list: 'some tags')
    get image_path image

    assert_response :ok

    assert_select '.tag_list', /some tags/
  end

  test 'displaying an image with no tag data gives us bupkis' do
    image = Image.create!(url: 'http://someurl')
    get image_path image

    assert_response :ok

    assert_select '.tag_list', /NADA/
  end

  # images/:id DELETE

  test 'deleting images is success' do
    image = Image.create!(url: 'http://someurl')

    delete image_path image.id

    refute Image.exists?(image.id)

    assert_response :found

    assert_redirected_to images_path
  end

  test 'deleting an invalid images throws' do
    assert_raise ActiveRecord::RecordNotFound do
      delete image_path 1
    end
  end

  test 'deleting images also deletes any associated image tags' do
    skip 'todo'
  end

  # images/new

  test 'displaying new image form is success' do
    get new_image_path

    assert_response :ok
  end

  test 'new image contains url input field' do
    get new_image_path

    assert_response :ok

    assert_select '.image_url'
    assert_select 'form input[type=url][name=?]', 'image[url]'
  end

  test 'new image contains tags input field' do
    get new_image_path

    assert_response :ok

    assert_select '.image_tag_list'
    assert_select '.tag_list_input'
  end

  test 'new image allows form submission' do
    get new_image_path

    assert_response :ok

    assert_select 'form[action=?]', images_path
    assert_select 'form input[type=submit][name=commit]'
  end
end
