class Api::DepartmentsController < ApplicationController
  def index
    @departments = Course.distinct(:department)
  end
end

