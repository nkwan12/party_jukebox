module Spotify
  class SpotifyObject
    def self.request(path, method: "GET", opts: {})
      opts[:format] ||= :json
      opts[:headers] ||= {}
      opts[:headers]["Authorization"] ||= "Bearer #{Spotify.access_token}"
      method = method.to_s.downcase
      response = HTTParty.send(method, api_url(path), opts)
      puts "REQUEST METHOD: #{ method }"
      puts "REQUEST OPTIONS: #{ opts }"
      puts "REQUEST URL: #{ api_url(path) }"
      if response.code == 401
        puts "Access token expired. Re-authorizing."
        Spotify.authorize
        opts[:headers]["Authorization"] ||= "Bearer #{Spotify.access_token}"
        response = HTTParty.send(method, api_url(path), opts)
      end
      puts "PARSED RESPONSE: #{ response.parsed_response }"
      puts "RESPONSE CODE: #{ response.code }"
      puts "SPOTIFY RESPONSE BODY: #{ response.body }"
      return response.body && JSON.parse(response.body)
    end

    private

      def self.api_url(path)
        return Spotify.api_base + path
      end
  end
end
