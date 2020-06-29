require 'test_helper'

class ImagesControllerTest < ActionDispatch::IntegrationTest
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

  # images GET

  test 'get images is success' do
    get images_path

    assert_response :ok
  end

  test 'images page should show create images link' do
    get images_path

    assert_select 'a' do |a_tags|
      assert_equal 1, a_tags.length
      assert_equal new_image_path, a_tags.first[:href]
    end
  end

  test 'images page should display saved images' do
    Image.create!([{ url: 'http://someurl' }, { url: 'http://someurl2' }])
    get images_path

    assert_select('.image') { |images| assert_equal 2, images.count }
  end

  # images POST

  test 'creating an image should save image' do
    assert_difference 'Image.count' do
      post images_path image: { url: 'http://someurl' }
    end
    assert_equal 'http://someurl', Image.last.url
    assert_response :found
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

  test 'posting image with invalid url keeps user text as value' do
    post images_path image: { url: 'bad url' }

    assert_select '.url_input[value=?]', 'bad url'
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

  test 'displaying an image should show image data' do
    image = Image.create!(url: 'http://someurl')
    get image_path image

    assert_response :ok

    assert_select 'img' do |images|
      assert_equal 'http://someurl', images.first[:src]
    end
  end

  # images/new

  test 'displaying new image form is success' do
    get new_image_path

    assert_response :ok
  end

  test 'new image contains url input field' do
    get new_image_path

    assert_response :ok

    assert_select 'form[action=?]', images_path
    assert_select 'form input', 3 do
      assert_select '[type=url][name=?]', 'image[url]'
      assert_select '[type=submit][name=commit]'
    end
  end
end
