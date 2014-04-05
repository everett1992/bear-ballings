class Api::Users::CoursesController < Api::Users::UserController
  def index
    @bins = @user.bins
  end
  
  def create
    course = findCourse(params[:_id])
    if course.nil?
      return
    end
    if params[:to_bin].blank? && params[:before_bin].blank?
      #add the course to a new bin if no bin is provided
      @bin = @user.add_course(course)
    elsif params[:before_bin].blank?
      addTo(course, params[:to_bin])
    end
    render json: :success
  end

  private
  def findCourse(_id)
    if _id.blank?
      render json: {error: 'Course _id cannot be nil'}, status: :unprocessable_entity
      return nil
    end
    course = Course.where(_id: _id).first
    if course.nil?
      render json: {error: "No course matching id #{_id} was found"}, status: :not_found
      return nil
    end
    return course
  end

  def addTo(course, bin_id)
    @bin = @user.bins.find(bin_id)
    if @bin
      #add the course to that bin
      @user.add_course(course, @bin)
    else
      render json: {error: 'No bin matching the provided id was found for this user'}, status: :not_found
    end
  end
end
