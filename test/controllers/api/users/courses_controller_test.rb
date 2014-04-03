require 'test_helper'

class Api::Users::CoursesControllerTest < ActionController::TestCase
  #--Index Tests
  test "Should redirect unlogged in users to login page" do
    logout
    get :index, {format: :json}
    assert_redirected_to login_form_path
  end

  test "Should redirect logged in user to user show" do
    login User.first
    get :index, {format: :json}
    assert_template :index
  end

  #--Adding Courses Tests
  test "Should fail when no course _id is provided" do
    login User.first
    post :create, {format: :json}
    assert_response :unprocessable_entity
    assert_equal "Course _id cannot be nil", JSON.parse(response.body)['error']
  end

  test "Should fail when no course matches provided _id" do
    login User.first
    post :create, {format: :json, _id: "THIS WILL NEVER BE A COURSE ID. THAT'S NOT HOW THOSE WORK. THIS SHOULD BE SAFE BY NOW"}
    assert_response :not_found
    assert_equal "No course matching the _id provided was found", JSON.parse(response.body)['error']
  end

  test "Default case should create new bin and adds course" do
    user = User.first
    course = Course.first
    login user
    user.bins.delete_all
    assert_difference('user.bins.count', 1) do
      post :create, {format: :json, _id: course._id}
      assert assigns(:bin).courses.include? course
    end
  end

  test "Default case should add new bin to the end of the bins" do
    user = User.first
    course = Course.first
    new_course = Course.last
    login user
    user.bins.delete_all
    user.add_course(course)
    post :create, {format: :json, _id: new_course._id}
    assert_equal(user.reload.bins.last, assigns(:bin))
  end

  #--Routing Tests
  test "Should route api/user/courses to api/user/courses#index" do
    assert_routing({method: 'get', path: 'api/user/courses'}, {
        format: :json,
        action: 'index',
        controller: 'api/users/courses'
    })
  end

  test "Should route POST api/user/courses to api/user/courses#create" do
    assert_routing({method: 'post', path: 'api/user/courses'}, {
        format: :json,
        action: 'create',
        controller: 'api/users/courses'
    })
  end
end
