class Bin
  include Mongoid::Document
  embedded_in :user
  has_and_belongs_to_many :courses
  
  # Validates each course is unique.
  # Validates that there is atleast one course.
end
