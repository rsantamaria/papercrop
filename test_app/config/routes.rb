TestApp::Application.routes.draw do
  resources :landscapes

  root :to => 'landscapes#index'
end
