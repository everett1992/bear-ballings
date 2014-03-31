class Api::Users::UserController < ApplicationController
  before_action :require_login

  def index
    render 'api/users/show'
  end
end
