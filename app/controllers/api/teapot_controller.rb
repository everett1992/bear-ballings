# Is a teapot
class Api::TeapotController < ApplicationController
  def teapot
    render json: {teapot: "I am a teapot" }, status: 418
  end
end
