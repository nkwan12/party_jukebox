class SongsController < ApplicationController
  before_action :set_currents

  def index
  end

  def search
  end

  def enqueue
  end

  private

  def set_currents
    @player = Spotify::Player.get
    @current_track = @player["item"]
    @playlist_id = Rails.cache.fetch("spotify_playlist_id") do
      @player["context"]["uri"].scan(/[^:]*$/)[0]
    end
    @tracks = Spotify::Playlist.get_tracks(@playlist_id)
    @current_index = @tracks.index { |track| @current_track["id"] == track["id"] }
    @queue_index = Rails.cache.read("spotify_queue_index")
    if @queue_index.nil? || @queue_index < @current_index
      @queue_index = @current_index + 1
    end
    @queue_index += 1 if @queue_index == @current_index + 1 &&
      @current_track["duration_ms"] - @player["progress_ms"] < 5000
    Rails.cache.write("spotify_queue_index", @queue_index)
  end
end
