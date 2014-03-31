class Api::SessionsController < ApplicationController
  def create
    @user = User.where(name: params[:user_name]).first
    if @user
      login @user
      render 'api/user/show'
    else
      render json: {error: 'No user matches the supplied information'}, status: :unauthorized
    end
  end

  def destroy
    logout
    render json: "Goodbye", status: 200
  end
end
