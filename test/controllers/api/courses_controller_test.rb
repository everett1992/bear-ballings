require 'test_helper'

class Api::CoursesControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, {format: 'json'}
    assert_response :success
    assert_not_nil assigns(:courses)
  end
end
