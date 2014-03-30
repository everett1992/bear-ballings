class Api::CoursesController < ApplicationController
  def index
    @courses = Course
      .where(query_params)
      .limit(params[:limit])
      .offset(params[:offset])
  end

  private

  def query_params
    params.permit(:department)
  end
end
