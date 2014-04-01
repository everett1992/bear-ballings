class Api::Users::CoursesController < Api::Users::UserController
  def index
    @bins = @user.bins
  end
end
