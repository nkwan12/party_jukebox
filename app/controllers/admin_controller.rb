class AdminController < ApplicationController

  def index
    redirect_to Spotify.auth_url and return if !Spotify.authorized?
    head :ok
  end

  def callback
    Spotify.authorize(params[:code])
    head :ok
  end
end
