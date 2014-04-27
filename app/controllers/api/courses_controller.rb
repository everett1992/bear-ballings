class Api::CoursesController < ApplicationController
  # List of all courses
  def index
    @courses = Course
      .where(query_params)
      .limit(params[:limit])
      .offset(params[:offset])
  end

  private

  # Limits parameters avaliable to only department
  def query_params
    params.permit(:department)
  end
end
