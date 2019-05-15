Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    resources :users
  end
  root "static_pages#home"
  get "static_pages/about"
  get "static_pages/contact"
  get "static_pages/help"
  get "static_pages/home"
end
