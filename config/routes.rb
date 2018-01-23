Rails.application.routes.draw do
  scope "/admin" do
    get "/", to: "admin#index", as: :admin
    get :login, to: "admin#login", as: :admin_login
    get :callback, to: "admin#callback", as: :admin_callback
  end
  scope "/songs" do
    get "/", to: "songs#index", as: :songs
    get :search, to: "songs#search", as: :songs_search
  end
end
