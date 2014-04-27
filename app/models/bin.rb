##
# Defines the bin model.
#
# A bin is a set of courses.
class Bin
  include Mongoid::Document
  embedded_in :user
  has_and_belongs_to_many :courses

  # Validates each course is unique.
  # Validates that there is atleast one course.

  def add_course(course)
    courses << course
    save
  end

  def remove_course(course)
    courses.delete(course)
    empty? ? destroy : save 
    return self
  end

  def empty?
    courses.empty?
  end
end
