require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Shoudl add a course to a bin" do
    user = User.first
    course = Course.first
    bin = user.bins.create

    assert_difference('bin.courses.count', 1) do
      assert_no_difference('user.bins.count') do
        user.add_course(course, bin)
      end
    end
  end

  test "Should create a new bin when courses are added without a bin" do
    user = User.first
    course = Course.first
    assert_difference('user.bins.count', 1) do
      bin = user.add_course(course)

      assert_equal 1, bin.courses.length
    end
  end

  test "Should remove a course from it's bin" do
    user = User.first

    # Clear all other bins first
    user.bins.delete_all

    course = Course.first
    bin = user.add_course(course)
    user.add_course(Course.last, bin)

    assert_difference('bin.reload.courses.count', -1) do
      assert_no_difference('user.reload.bins.count') do
        assert_not_nil user.remove_course(course)
      end
    end
  end

  test "Should remove a bin when it's last course is removed" do
    user = User.first

    # Clear all other bins first
    user.bins.delete_all

    course = Course.first
    user.add_course(course)

    assert_difference('user.reload.bins.count', -1) do
      assert_nil user.remove_course(course)
    end
  end
end
