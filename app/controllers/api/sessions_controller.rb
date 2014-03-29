class Api::SessionsController < ApplicationController
  def create
    @user = Users.where(name: params[:user_name]).first
    if @user
      session[:user_id]=@user._id
      render 'api/users/show'
    else
      render json: {error: 'No user matches the supplied information'}, status: :unauthorized
    end
  end
  def destroy
    session[:user_id]=nil;
    render json: "Goodbye", status: 200
  end
end
