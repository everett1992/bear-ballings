require 'test_helper'

class Api::CoursesControllerTest < ActionController::TestCase
  test 'should get index' do
    get :index, {format: 'json'}
    assert_response :success
    assert_template :index
    assert_not_nil assigns(:courses)
  end

  test 'index should return all courses' do
    get :index, {format: 'json'}
    assert_equal Course.count, assigns(:courses).length
  end

  test 'index should limit courses' do
    limit = 10
    courses = Course.all.take(limit)
    get :index, {format: 'json', limit: limit}
    assert_equal courses, assigns(:courses)
  end

  test 'index should offset courses' do
    offset = 10
    limit = 10
    courses = Course.limit(limit + offset).drop(offset)
    get :index, {format: 'json', limit: 10, offset: offset}
    assert_equal courses, assigns(:courses)
  end

  test 'index should query by department' do
    dep = 'CSC'
    courses = Course.all.select { |c| c.department == dep }
    get :index, {format: 'json', department: dep}
    assert_response :success
    assert_equal courses, assigns(:courses)
  end

  test "Should route api/courses to api/courses#index" do
    assert_routing({method: 'get', path: 'api/courses'}, {
        format: :json,
        action: 'index',
        controller: 'api/courses'
    })
  end
end
