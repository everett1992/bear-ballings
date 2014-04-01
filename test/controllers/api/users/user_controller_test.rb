require 'test_helper'

class Api::Users::UserControllerTest < ActionController::TestCase
  test "Requires login redirects to login" do
    logout
    get :index, {format: :json}
    assert_redirected_to login_form_path
  end

  test "Requires login redirects to user show" do
    login User.first
    get :index, {format: :json}
    assert_template 'api/users/show'
  end
end

