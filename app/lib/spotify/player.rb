module Spotify
  class Player < SpotifyObject
    def self.get
      request("me/player")
    end

    def self.toggle_shuffle(state)
      request("me/player/shuffle", method: :put, opts: {
        query: { state: state }.to_query,
        headers: { "Accept" => "application/json" }
      })
    end

    def self.play(context = nil, index = 0)
      body = {}
      body[:context_uri] = context if context
      request("me/player/play", method: :put, opts: {
        body: body.to_json,
        headers: { "Accept" => "application/json" }
      })
    end
  end
end
