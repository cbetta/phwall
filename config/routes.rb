Rails.application.routes.draw do
  get "/table", to: "appointments#table"
  root 'appointments#index'
end
