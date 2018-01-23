class SongsController < ApplicationController
  before_action :set_currents, except: [:search]

  def index
  end

  def search
    @query = params[:query]
    @results = Spotify::Track.search(@query)
    @tracks = @results["tracks"]["items"]
  end

  def enqueue
    track_index = @tracks.map {|t| t["id"]}.index(params[:track_id])
    if track_index && (track_index < @current_index || track_index > @queue_index)
      r = Spotify::Playlist.reorder(@playlist_id, track_index, @queue_index)
    elsif !track_index
      r = Spotify::Playlist.add(@playlist_id, params[:track_uri], @queue_index)
    end

    flash[:success] = "#{params[:track_name]} added to queue!"
    redirect_to songs_search_path(query: params[:query])
  end

  private

  def set_currents
    @player = Spotify::Player.get
    @current_track = @player["item"]
    @playlist_id = Rails.cache.fetch("spotify_playlist_id") do
      @player["context"]["uri"].scan(/[^:]*$/)[0]
    end
    @tracks = Spotify::Playlist.get_tracks(@playlist_id)
    @current_index = @tracks.index { |track| @current_track["id"] == track["id"] } || -1
    @queue_index = Rails.cache.read("spotify_queue_index")
    puts "QUEUE INDEX INITIAL: #{ @queue_index }"
    if @queue_index.nil? || @queue_index <= @current_index
      @queue_index = @current_index + 1
    end
    @queue_index += 1 if @queue_index == @current_index + 1 &&
      @current_track["duration_ms"] - @player["progress_ms"] < 5000
    Rails.cache.write("spotify_queue_index", @queue_index)
    puts "QUEUE INDEX FINAL: #{ @queue_index }"
  end
end
