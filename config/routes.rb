BearBallings::Application.routes.draw do
  namespace :api, defaults: {format: :json} do
    get 'departments'         => 'departments#index'
    get 'courses'             => 'courses#index'
    post 'login'              => 'sessions#create', as: :login
    post 'logout'              => 'sessions#destroy', as: :logout
    #get 'courses/:department' => 'courses#index'
  end
end
