class User
  include Mongoid::Document
  field :n, as: :name, type: String
  embeds_many :bins

  # Validates that no bin has duplicate courses.

  ##
  # Adds a +course+ to a +bin+.
  #
  # If no +bin+ is passed a new bin is created
  # The bin is returned
  def add_course(course, bin=Bin.new)
    bin.courses << course
    return bin
  end

  def remove_course(course, bin)

  end
end
