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
    id = "THIS WILL NEVER BE A COURSE ID. THAT'S NOT HOW THOSE WORK. THIS SHOULD BE SAFE BY NOW"
    post :create, {format: :json, _id: id}
    assert_response :not_found
    assert_equal "No course matching id #{id} was found", JSON.parse(response.body)['error']
  end

  test "Default case should create new bin and adds course" do
    user = User.first
    course = Course.first
    login user
    user.bins.delete_all
    assert_difference('user.reload.bins.count', 1) do
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

  test "Passing a bin and a couse should place the course in the bin" do
    user = User.first
    course = Course.first
    new_course = Course.last
    login user
    user.bins.delete_all
    bin = user.add_course(course)
    assert_difference("bin.reload.course_ids.count", 1) do
      post :create, {format: :json, _id: new_course._id, to_bin: bin._id}
    end
  end

  test "Passing a course, and a before_bin id should create a new bin before before_bin" do
    user = User.first
    new_course = Course.first

    login user
    user.bins.delete_all
    bin = user.add_course(Course.last)

    assert_difference("user.reload.bins.count", 1) do
      post :create, {format: :json, _id: new_course._id, before_bin: bin._id}
    end

    new_bin_index = user.bins.index { |b| b.courses.include? new_course }
    other_bin_index = user.bins.index(bin)

    # If `other_bin`'s index is 0 the new bin cannot be before it.
    assert_not_equal 0, other_bin_index, "Other bin is the first bin"
    assert_equal other_bin_index - 1, new_bin_index
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
