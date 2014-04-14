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
  def add_course(course, bin=bins.new)
    if courses.include? course
      raise DuplicateCourse.new("User has already added #{course} to a bin")
    end

    unless bins.include? bin
      raise SomeoneElsesBin.new("bin not owned by this user.")
    end

    bin.add_course course
    return bin
  end

  def remove_course(course)
    bin = bins.where(:course_ids => course).first
    if bin.nil?
      raise NoCourseFound.new("User does not have course #{course} in any bin")
    end

    return bin.remove_course(course)
  end

  def create_bin_before(course, bin)
    index = bins.index(bin)

    if index.nil?
      raise SomeoneElsesBin.new("bin not owned by this user.")
    end

    new_bin = bins.build(courses: [course])
    User.where(_id: self.id).update_all("$push" => {
      bins: { "$each" => [new_bin.serializable_hash],
              "$position" => index }})

    bin = bins.find(new_bin._id)
    return bin
  end

  def move_course(course, bin)
    remove_course(course)

    # Make sure the list of bins has updated with the removed course.
    reload

    add_course(course, bin)
  end

  def courses
    bins.map(&:courses).flatten
  end
end

# Should these be here?
class DuplicateCourse < ArgumentError
end

class SomeoneElsesBin < ArgumentError
end

class NoCourseFound < ArgumentError
end
