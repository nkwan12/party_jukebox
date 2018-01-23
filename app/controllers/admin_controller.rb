class AdminController < ApplicationController

  def index
    redirect_to admin_login_path and return if !Spotify.authorized?

    @playlists = Spotify::Playlist.all
  end

  def login
    redirect_to Spotify.auth_url
  end

  def callback
    Spotify.authorize(params[:code])

    redirect_to admin_path
  end

  def start_party
    Rails.cache.write("spotify_playlist_id", params[:playlist_id])

    flash[:success] = "Party Started!!"
    redirect_to admin_path
  end
end
