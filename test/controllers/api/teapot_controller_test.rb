require 'test_helper'

class Api::TeapotControllerTest < ActionController::TestCase
   test "Is a teapot" do
     get :teapot
     assert_response 418
     assert_equal "I am a teapot", JSON.parse(response.body)['teapot']
   end

   test "Should route api/teapot to api/teapot#teapot" do
    assert_routing({method: 'get', path: 'api/teapot'}, {
        format: :json,
        action: 'teapot',
        controller: 'api/teapot'
    })
   end
end
