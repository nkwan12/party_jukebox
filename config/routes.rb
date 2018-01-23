Rails.application.routes.draw do
  root to: redirect("/songs")
  scope "/admin" do
    get "/", to: "admin#index", as: :admin
    get :login, to: "admin#login", as: :admin_login
    get :callback, to: "admin#callback", as: :admin_callback
    post :start_party, to: "admin#start_party", as: :start_party
  end
  scope "/songs" do
    get "/", to: "songs#index", as: :songs
    get :search, to: "songs#search", as: :songs_search
    post :enqueue, to: "songs#enqueue", as: :songs_enqueue
  end
end
