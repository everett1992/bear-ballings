# Defines API endpoints to login or logout.
class SessionsController < ApplicationController
  # login
  def create
    @user = User.where(login: params[:login]).first
    respond_to do |format|
      if @user
        login @user
        format.json { render 'api/users/show' }
        format.html { redirect_to root_path }
      else
        format.json { render json: {error: 'No user matches the supplied information'}, status: :unauthorized }
        format.html { redirect_to login_path, notice: "Invalid login or password." }
      end
    end
  end

  # logout
  def destroy
    logout
    respond_to do |format|
      format.json { render json: "Goodbye", status: 200 }
      format.html { redirect_to login_path }
    end
  end
end
