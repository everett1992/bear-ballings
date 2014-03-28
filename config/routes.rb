BearBallings::Application.routes.draw do
  namespace :api, defaults: {format: :json} do
    get 'departments'         => 'departments#index'
    get 'courses'             => 'courses#index'
    #get 'courses/:department' => 'courses#index'
  end
end
