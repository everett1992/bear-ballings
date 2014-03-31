require 'test_helper'

class Api::SessionsControllerTest < ActionController::TestCase

  test "Fail when no username is supplied" do
    post :create, {format: :json}
    assert_response :unauthorized
    assert_nil assigns(:user)
  end

  test "Fail when username doesn't exist" do
    post :create, {format: :json, user_name: 'Dik Phuk'}
    assert_response :unauthorized
    assert_nil assigns(:user)
  end

  test "Renders the user/show template" do
    post :create, {format: :json, user_name: User.first.name}
    assert_response :success
    assert_template 'api/user/show'
    assert_not_nil flash[:notice]
  end

  test "Logs in user when username exists" do
    user = User.where(name: 'palacee1').first

    post :create, {format: :json, user_name: user.name}
    assert_equal user, assigns(:user)
    assert_equal user._id, session[:user_id]
  end

  test "Logout resets session vars" do
    post :destroy
    assert_response 200
    assert_nil session[:user_id]
    assert_not_nil flash[:notice]
  end

  test "Should route api/login to api/sessions#destroy" do
    assert_routing({method: 'post', path: 'api/login'}, {
        format: :json,
        action: 'create',
        controller: 'api/sessions'
    })
  end

  test "Should route api/logout to api/sessions#destroy" do
    assert_routing({method: 'post', path: 'api/logout'}, {
        format: :json,
        action: 'destroy',
        controller: 'api/sessions'
    })
  end
end
