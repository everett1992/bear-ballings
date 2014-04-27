# Defines front end endpoints and requires the user is loged in to see the
# index.
class MainController < ApplicationController
  before_action :require_login, only: [:index]
  def index
  end

  def login
  end
end
