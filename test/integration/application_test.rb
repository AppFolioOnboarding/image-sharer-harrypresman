require 'test_helper'

class ApplicationTest < ActionDispatch::IntegrationTest
  test 'root path returns OK' do
    get root_path
    assert_response :ok
  end
end
