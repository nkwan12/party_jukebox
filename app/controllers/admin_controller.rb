class AdminController < ApplicationController
  before_action :require_token

  def index
    redirect_to admin_login_path and return if !Spotify.authorized?

    @playlists = Spotify::Playlist.all
  end

  def login
    redirect_to Spotify.auth_url
  end

  def callback
    res = Spotify.authorize(params[:code])

    if res.code != 200
      head res.body
    else
      redirect_to admin_path
    end
  end

  def start_party
    playlist_id = params[:playlist_uri].scan(/[^:]*$/)[0]
    Rails.cache.delete("spotify_queue_index")
    Rails.cache.write("spotify_playlist_id", playlist_id)

    flash[:success] = "Party Started!!"
    redirect_to admin_path
  end

  def end_party
    Rails.cache.delete("spotify_queue_index")
    Rails.cache.delete("spotify_playlist_id")
    Rails.cache.delete("spotify_access_token")
    Rails.cache.delete("spotify_refresh_token")

    flash[:success] = "Party Ended :("
  end
end
