Rails32::Application.routes.draw do
  resources :landscapes do
    post 'crop', :on => :member
  end

  root :to => 'landscapes#index'
end
