class Api::DepartmentsController < ApplicationController
  # List of unique departments
  def index
    @departments = Course.distinct(:department)
  end
end
