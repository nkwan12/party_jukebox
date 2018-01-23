class AdminController < ApplicationController

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
end
