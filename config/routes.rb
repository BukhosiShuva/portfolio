Rails.application.routes.draw do
  resources :contacts, only: [ :new, :create ]
  get "contacts/new"
  get "contacts/create"
  get "pages/landing"
  get "pages/home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  # Specific routes for the contact form

  post "contact", to: "pages#send_contact_form", as: :send_contact_form_pages
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "pages#landing"
  get "/home", to: "pages#home"
  get "/about", to: "pages#about"
  get "/portfolio", to: "pages#portfolio"
  get "/contact", to: "pages#contact"
  get "/portfolioprojectEvo", to: "pages#portfolioprojectEvo"
  get "/portfolioprojectEmerge", to: "pages#portfolioprojectEmerge"
  get "/portfolioprojectCurl", to: "pages#portfolioprojectCurl"
  # get "/pwa", to: "pages#pwa"
  post "contact", to: "pages#contact_submit"
end
