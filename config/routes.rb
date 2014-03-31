BearBallings::Application.routes.draw do
  root 'main#index'
  get 'login' => 'main#login', as: :login_form

  namespace :api, defaults: {format: :json} do
    post 'login'              => 'sessions#create', as: :login
    post 'logout'              => 'sessions#destroy', as: :logout

    get 'departments'         => 'departments#index'
    get 'courses'             => 'courses#index'
    get 'teapot'              => 'teapot#teapot'
    #get 'courses/:department' => 'courses#index'
  end
end
