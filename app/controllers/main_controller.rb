class MainController < ApplicationController
  before_action :require_login, only: [:index]
  def index
  end

  def login
  end
end
