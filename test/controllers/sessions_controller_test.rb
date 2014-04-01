require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  test "Redirect back to login when no username is supplied" do
    post :create
    assert_redirected_to login_path
    assert_nil assigns(:user)
  end

  test "Redirects to login with errors when login fails" do
    post :create, {user_name: 'Dik Phuk'}
    assert_redirected_to login_path
    assert_nil assigns(:user)
  end

  test "Redirects to root when login succeeds" do
    user = User.first
    post :create, {user_name: user.name}
    assert_redirected_to root_path
    assert_equal user, assigns(:user)
  end

  test "Logout resets session vars" do
    post :destroy
    assert_redirected_to login_path
    assert_nil session[:user_id]
    assert_not_nil flash[:notice]
  end

  #:: Testing json responses

  test "Json: Fail when no username is supplied" do
    post :create, {format: :json}
    assert_response :unauthorized
    assert_nil assigns(:user)
  end

  test "Json: Fail when username doesn't exist" do
    post :create, {format: :json, user_name: 'Dik Phuk'}
    assert_response :unauthorized
    assert_nil assigns(:user)
  end

  test "Json: Renders the users/show template" do
    post :create, {format: :json, user_name: User.first.name}
    assert_response :success
    assert_template 'api/users/show'
    assert_not_nil flash[:notice]
  end

  test "Json: Logs in user when username exists" do
    user = User.where(name: 'palacee1').first

    post :create, {format: :json, user_name: user.name}
    assert_equal user, assigns(:user)
    assert_equal user._id, session[:user_id]
  end

  test "Json: Logout resets session vars" do
    post :destroy, {format: :json}
    assert_response 200
    assert_nil session[:user_id]
    assert_not_nil flash[:notice]
  end

  #:: Testing routes

  test "Should route /login to api/sessions#destroy" do
    assert_routing({method: 'post', path: 'login'}, {
        action: 'create',
        controller: 'sessions'
    })
  end

  test "Should route logout to api/sessions#destroy" do
    assert_routing({method: 'post', path: 'logout'}, {
        action: 'destroy',
        controller: 'sessions'
    })
  end
end
