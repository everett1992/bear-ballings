class Api::CoursesController < ApplicationController
  def index
    @courses = Courses.limit(params[:limit]).offset(params[:offset])
  end
end
