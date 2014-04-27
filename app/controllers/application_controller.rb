# All controllers inhert from this.
class ApplicationController < ActionController::Base

  private

  def require_login
    redirect_to login_form_path, notice: 'Please login' unless current_user
  end

  def current_user
    @user ||= User.where(_id: session[:user_id]).first if session[:user_id]
  end

  def login user
    unless user.is_a? User
      throw ArugmentError.new("user must be a valid user")
    end

    flash[:notice] = "Logged in as #{user.name}."
    session[:user_id] = user._id
  end

  def logout
    flash[:notice] = "Logged out."
    session[:user_id] = nil
  end
end
