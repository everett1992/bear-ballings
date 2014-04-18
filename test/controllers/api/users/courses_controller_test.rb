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
    assert_no_difference("user.reload.bins.count", 1) do
      assert_difference("bin.reload.course_ids.count", 1) do
        post :create, {format: :json, _id: new_course._id, to_bin: bin._id}
      end
    end
  end

  test "Passing a course, and a before_bin id should create a new bin before before_bin" do
    user = User.first

    login user
    user.bins.delete_all

    courses = Course.limit(10).to_a

    # Add some courses
    courses.shift(4).each do |course|
      user.add_course(course)
    end

    # Add this course, and remember it because we will add a course before it.
    bin = user.add_course(courses.shift())

    # ADd more courses
    courses.each do |course|
      user.add_course(course)
    end

    # Add a course before the one we remembed.
    new_course = Course.last
    assert_difference("user.reload.bins.count", 1) do
      post :create, {format: :json, _id: new_course._id, before_bin: bin._id}
    end

    new_bin_index = user.bins.index { |b| b.courses.include? new_course }
    other_bin_index = user.bins.index(bin)

    # Make sure both bins exist
    assert_not_equal nil, other_bin_index, "Before bin index was nil"
    assert_not_equal nil, new_bin_index, "New bin index was nil"
    assert_equal other_bin_index - 1, new_bin_index
  end

  #--Removing Courses
  test "Should fail when no _id is provided" do
    login User.first
    delete :destroy, {format: :json}
    assert_response :unprocessable_entity
    assert_equal 'Course _id cannot be nil', JSON.parse(response.body)['error']
  end

  test "Should fail when no course matches the provided _id" do
    login User.first
    id = "THIS WILL NEVER BE A COURSE ID. THAT'S NOT HOW THOSE WORK. THIS SHOULD BE SAFE BY NOW"
    delete :destroy, {format: :json, _id: id}
    assert_response :not_found
    assert_equal "No course matching id #{id} was found", JSON.parse(response.body)['error']
  end

  test "Should fail when trying to delete a valid course a user does not have" do
    user = User.first
    login user
    user.bins.destroy_all
    user.add_course(Course.first)
    delete :destroy, {format: :json, _id: Course.last._id}
    assert_response :not_found
    assert_equal "User has no course matching id #{Course.last._id}", JSON.parse(response.body)['error']
  end
   
  test "Should remove a course but not the bin when a valid _id is provided" do
    user = User.first
    login user
    user.bins.destroy_all
    bin = user.add_course(Course.first)
    user.add_course(Course.last, bin)
    course = user.courses.first
    assert_no_difference("user.reload.bins.count") do
      assert_difference("user.reload.courses.count", -1) do
        delete :destroy, {format: :json, _id: course._id}
      end
    end
    assert_response :no_content
  end
  
  test "Should remove a bin when the last course is removed" do
    user = User.first
    login user
    user.bins.destroy_all
    bin = user.add_course(Course.first)
    course = user.courses.first
    assert_difference("user.reload.bins.count", -1) do
      delete :destroy, {format: :json, _id: course._id}
    end
    assert_response :ok
    assert_equal "Removed bin #{bin._id}", JSON.parse(response.body)['message']
    assert_equal bin._id.to_s, JSON.parse(response.body)['_id']
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

  test "Should route DELETE api/user/courses to api/user/courses#destroy" do
    assert_routing({method: 'delete', path: 'api/user/courses'}, {
        format: :json,
        action: 'destroy',
        controller: 'api/users/courses'
    })
  end

end
