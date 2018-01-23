module Spotify
  class Playlist < SpotifyObject
    def self.all
      request("me/playlists")["items"].map { |i| i.symbolize_keys if i.is_a?(Hash) }
    end

    def self.get(playlist_id)
      request("users/nkwan12/playlists/#{playlist_id}")
    end

    def self.get_tracks(playlist_id)
      res = request("users/nkwan12/playlists/#{playlist_id}/tracks")
      tracks = res["items"]
      while res["next"] do
        tracks += request("users/nkwan12/playlists/#{playlist_id}/tracks")["items"]
      end

      return tracks.map {|item| item["track"]}
    end
  end
end
