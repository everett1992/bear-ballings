class Api::Users::CoursesController < Api::Users::UserController
  def index
    @bins = @user.bins
  end
  
  def create
    if params[:_id].blank?
      render json: {error: 'Course _id cannot be nil'}, status: :unprocessable_entity
    else 
      course = Course.where(_id: params[:_id]).first
      if course.nil?
        render json: {error: 'No course matching the _id provided was found'}, status: :not_found
      else
        @bin = @user.add_course(course)
        render json: :success
      end
    end
  end
end
