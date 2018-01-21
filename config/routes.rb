Rails.application.routes.draw do
  scope "/admin" do
    get "/", to: "admin#index"
    get "/callback", to: "admin#callback", as: :admin_callback
  end
end
