class Bin
  include Mongoid::Document
  belongs_to :user
  has_and_belongs_to_many :courses
  
  # Validates each course is unique.
  # Validates that there is atleast one course.
  
  def add_course(course)
    courses << course
    save
  end

  def remove_course(course)
    courses.delete(course)
    return empty? ? destroy && nil : save && self
  end

  def empty?
    courses.empty?
  end
end
