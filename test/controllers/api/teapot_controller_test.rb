require 'test_helper'

class Api::TeapotControllerTest < ActionController::TestCase
   test "Is a teapot" do
     get :teapot
     assert_response 418
     assert_equal "I am a teapot", JSON.parse(response.body)['teapot']
   end
end
