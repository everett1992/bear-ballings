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
    assert_equal Courses.count, assigns(:courses).length
  end

  test 'index should limit courses' do
    limit = 10
    courses = Courses.all.take(limit)
    get :index, {format: 'json', limit: limit}
    assert_equal courses, assigns(:courses)
  end

  test 'index should offset courses' do
    offset = 10
    limit = 10
    courses = Courses.limit(limit + offset).drop(offset)
    get :index, {format: 'json', limit: 10, offset: offset}
    assert_equal courses, assigns(:courses)
  end
end
