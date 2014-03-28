class Api::DepartmentsController < ApplicationController
  def index
    @departments = Courses.distinct(:department)
  end
end

