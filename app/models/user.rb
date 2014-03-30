class User
  include Mongoid::Document
  field :n, as: :name, type: String
  has_many :bins, dependent: :destroy

  # Validates that no bin has duplicate courses.

  ##
  # Adds a +course+ to a +bin+.
  #
  # If no +bin+ is passed a new bin is created
  # The bin is returned
  def add_course(course, bin=bins.new)
    bin.add_course course
    return bin
  end

  def remove_course(course)
    bin = bins.where(:course_ids => course).first

    return bin.remove_course(course)
  end
end
