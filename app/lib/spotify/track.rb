module Spotify
  class Track < SpotifyObject
    def self.search(query)
      request("search", opts: { query: { q: query, limit: 10, type: "track" } })
    end
  end
end