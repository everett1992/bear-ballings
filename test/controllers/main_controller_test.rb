require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "Index should redirect to login" do
    logout
    get :index
    assert_redirected_to login_form_path
  end

  test "Index should render index view" do
    login User.first
    get :index
    assert_template :index
  end

  test "Login should render the login view" do
    get :login
    assert_template :login
  end
end
