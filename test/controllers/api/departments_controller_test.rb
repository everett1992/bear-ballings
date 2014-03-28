require 'test_helper'

class Api::DepartmentsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, {format: 'json'}
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:departments)
  end
end
