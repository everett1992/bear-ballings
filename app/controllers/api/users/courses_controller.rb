class Api::Users::CoursesController < Api::Users::UserController
  def index
    @bins = @user.bins
  end

  def create
    course = find_course(params[:_id])
    if course.nil?
      return
    end

    if params[:to_bin].blank? && params[:before_bin].blank?
      #add the course to a new bin if no bin is provided
      @bin = @user.add_course(course)
    elsif params[:to_bin] && params[:before_bin].blank?
      add_to(course, params[:to_bin])
    elsif params[:before_bin] && params[:to_bin].blank?
      add_before(course, params[:before_bin])
    else
      render json: {error: 'Cannot add both to and before a bin.'}, status: :unprocessable_entity
    end

    render :show
  end

  def destroy
    course =  find_course(params[:_id])
    if course
      if  @user.courses.include? course
        bin = @user.remove_course(course)
        if bin.destroyed?
          render json: {message: "Removed bin #{bin._id}", _id: bin._id.to_s}, status: :ok
        else
          render json: nil, status: :no_content
        end
      else
        render json: {error: "User has no course matching id #{course._id}"}, status: :unprocessable_entity
      end
    end
  end

  private

  def find_course(_id)
    if _id.blank?
      render json: {error: 'Course _id cannot be nil'}, status: :unprocessable_entity
      return nil
    end
    course = Course.where(_id: _id).first
    if course.nil?
      render json: {error: "No course matching id #{_id} was found"}, status: :unprocessable_entity
      return nil
    end
    return course
  end

  def add_to(course, bin_idx)
    if (0..@user.bins.count).include? bin_idx
      # Add the course to the bin with the passed index.
      @bin = @user.bins[bin_idx]
      @user.add_course(course, @bin)
    else
      render json: {error: "Index out of range, must be between 0 and #{@user.bins.count}"}, status: :unprocessable_entity
    end
  end

  def add_before(course, bin_idx)
    if (0..@user.bins.count).include? bin_idx
      before_bin = @user.bins[bin_idx]
      @bin = @user.create_bin_before(course, before_bin)
    else
      render json: {error: "Index out of range, must be between 0 and #{@user.bins.count}"}, status: :unprocessable_entity
    end
  end
end
