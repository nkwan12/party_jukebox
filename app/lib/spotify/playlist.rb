module Spotify
  class Playlist < SpotifyObject
    def self.create(body = {})
      opts = {
        body: body,
        headers: { "Accept" => "application/json" }
      }
      request("users/nkwan12/playlists", method: :post, opts: opts)
    end

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

      return tracks && tracks.map {|item| item["track"]}
    end

    def self.add(playlist_id, track_uris, insert_index, set_queue = true)
      track_uris = [track_uris] unless track_uris.is_a?(Array)
      Rails.cache.write("spotify_queue_index", insert_index + 1) if set_queue
      request("users/nkwan12/playlists/#{playlist_id}/tracks", method: :post, opts: {
        body: { uris: track_uris, position: insert_index }.to_json,
        headers: { "Accept" => "application/json" }
      })
    end

    def self.reorder(playlist_id, from_index, to_index)
      Rails.cache.write("spotify_queue_index", to_index + 1) if from_index > to_index
      request("users/nkwan12/playlists/#{playlist_id}/tracks", method: :put, opts: {
        body: { range_start: from_index, insert_before: to_index }.to_json,
        headers: { "Accept" => "application/json" }
      })
    end
  end
end
