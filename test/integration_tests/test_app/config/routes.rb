ChecklistApplication.routes.draw do
  get "/", to: "lists#index"
  resources :lists

  get "/lists/:list_id/items", to: "items#index"
  get "/lists/:list_id/items/new", to: "items#new"
  get "/lists/:list_id/items/:id", to: "items#show"
  get "/lists/:list_id/items/:id/edit", to: "items#edit"
  post "/lists/:list_id/items", to: "items#create"
  patch "/lists/:list_id/items/:id", to: "items#update"
  put "/lists/:list_id/items/:id", to: "items#update"
  delete "/lists/:list_id/items/:id", to: "items#destroy"
  # resources :welcome

  get "/missing_view", to: "lists#test_view"
  get "/missing_layout", to: "lists#test_layout"
  # get "/", to: "welcome#index"
  # get "/index/:id/chief/", to: "welcome#show"
  # get "/index/:id(/:di(/:ii(/params/:bb)))", to: "welcome#articles"
end
