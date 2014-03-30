require 'test_helper'

class Api::DepartmentsControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, {format: 'json'}
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:departments)
  end

  test "Should route api/departments to api/courses#index" do
    assert_routing({method: 'get', path: 'api/departments'}, {
        format: :json,
        action: 'index',
        controller: 'api/departments'
    })
  end
end
