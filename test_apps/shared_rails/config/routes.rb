Rails.application.routes.draw do
  resources :landscapes do
    post 'crop', :on => :member
  end
end
