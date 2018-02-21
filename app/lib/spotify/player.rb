module Spotify
  class Player < SpotifyObject
    def self.get
      request("me/player")
    end

    def self.play(context = nil)
      body = {}
      body[:context_uri] = context if context
      request("me/player/play", method: :put, opts: {
        body: body.to_json,
        headers: { "Accept" => "application/json" }
      })
    end
  end
end
