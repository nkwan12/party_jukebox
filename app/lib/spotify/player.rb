module Spotify
  class Player < SpotifyObject
    def self.get
      request("me/player")
    end
  end
end
