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
      assert @user.remove_course(course).destroyed?
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

  #:: Create bin before

  test "Should error if the passed bin belongs to another user" do
    course = Course.first
    bin = User.last.bins.first

    assert_raise SomeoneElsesBin do
      @user.create_bin_before(course, bin)
    end
  end

  test "Should accept a bin belonging to itself" do
    course = Course.first
    bin = @user.add_course course

    assert_nothing_raised do
      @user.create_bin_before(course, bin)
    end
  end

  test "Should create a new bin before passed bin." do
    course = Course.first
    bin = @user.add_course Course.last

    new_bin = nil
    assert_difference('@user.reload.bins.count', 1) do
      new_bin = @user.create_bin_before(course, bin)
    end
    new_index = @user.bins.index(new_bin)
    index = @user.bins.index(bin)

    # Both indexes should have been found.
    assert_not_equal nil, index
    assert_not_equal nil, new_index

    assert_equal index - 1, new_index
  end

  test "Should create a new bin before the passed bin" do
  end

end
