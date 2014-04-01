require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    @user = User.first
    @user.bins.delete_all
  end

  #:: Adding courses

  test "Should add a course to a bin" do
    course = Course.first
    bin = @user.bins.create

    assert_difference('bin.courses.count', 1) do
      assert_no_difference('@user.bins.count') do
        @user.add_course(course, bin)
      end
    end
  end

  test "Should create a new bin when courses are added without a bin" do
    course = Course.first

    assert_difference('@user.bins.count', 1) do
      bin = @user.add_course(course)

      assert_equal 1, bin.courses.length
    end
  end

  test "Should throw an error when a course is added to another user's bin" do
    course = Course.first
    other_user = User.last
    bin = other_user.bins.create()

    assert_raise SomeoneElsesBin do
      @user.add_course(course, bin)
    end
  end

  test "Should throw an error when a duplicate course is added" do
    course = Course.first

    # Add the course once.
    @user.add_course(course)

    assert_raise DuplicateCourse do
      @user.add_course(course)
    end
  end

  #:: Removing courses

  test "Should remove a course from it's bin" do
    course = Course.first

    bin = @user.add_course(course)
    @user.add_course(Course.last, bin)

    assert_difference('bin.reload.courses.count', -1) do
      assert_no_difference('@user.reload.bins.count') do
        assert_not_nil @user.remove_course(course)
      end
    end
  end

  test "Should remove a bin when it's last course is removed" do
    course = Course.first

    @user.add_course(course)

    assert_difference('@user.reload.bins.count', -1) do
      assert_nil @user.remove_course(course)
    end
  end

  test "Should throw NoCouseFound exception when the user doesn't have the course" do
    course = Course.first

    assert_raise NoCourseFound do
      @user.remove_course course
    end
  end

  #:: Moving courses

  test "Move should require a course and a bin" do
    course = Course.first
    @user.add_course course

    assert_raise ArgumentError do
      @user.move_course course
    end
  end
end
