Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'get_video_info' => 'home#get_video_info', as: :get_video_info
end
