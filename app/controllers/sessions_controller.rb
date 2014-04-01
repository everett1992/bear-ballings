class SessionsController < ApplicationController
  def create
    @user = User.where(name: params[:user_name]).first
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

  def destroy
    logout
    respond_to do |format|
      format.json { render json: "Goodbye", status: 200 }
      format.html { redirect_to login_path }
    end
  end
end
