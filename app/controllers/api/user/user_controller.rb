class Api::User::UserController < ApplicationController
  before_action :require_login

  def index
    render 'api/user/show'
  end
end
