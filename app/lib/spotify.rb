module Spotify
  mattr_accessor :api_base, :redirect_uri, :client_id, :client_secret, :scope
  @@api_base = "https://api.spotify.com/v1/"
  @@redirect_uri = ENV["spotify_redirect_uri"]
  @@client_id =  ENV["spotify_client_id"]
  @@client_secret = ENV["spotify_client_secret"]
  @@scope = "playlist-read-private playlist-modify-private user-read-currently-playing " \
    "user-read-playback-state user-modify-playback-state streaming"

  def self.access_token
    Rails.cache.read("spotify_access_token")
  end

  def self.access_token=(val)
    Rails.cache.write("spotify_access_token", val)
  end

  def self.refresh_token
    Rails.cache.read("spotify_refresh_token")
  end

  def self.refresh_token=(val)
    Rails.cache.write("spotify_refresh_token", val)
  end

  def self.auth_url
    query = {
      response_type: "code",
      client_id: client_id,
      scope: scope,
      redirect_uri: redirect_uri
    }.to_query
    return "https://accounts.spotify.com/authorize?#{query}"
  end

  def self.authorize(auth_code = nil)
    creds = Base64.strict_encode64("#{client_id}:#{client_secret}")
    if !auth_code && refresh_token
      puts "Reauthorizing from refresh token."
      headers = {
        "Authorization" => "Basic #{creds}"
      }
      body = {
        grant_type: "refresh_token",
        refresh_token: refresh_token
      }
    elsif auth_code
      headers = {
        "Authorization" => "Basic #{creds}"
      }
      body = {
        code: auth_code,
        redirect_uri: redirect_uri,
        grant_type: "authorization_code"
      }
    else
      raise AuthenticationError, "Must have either code or refresh token."
    end
    puts "Authorization body: #{ body }"
    puts "Authorization headers: #{ headers }"
    res = HTTParty.post("https://accounts.spotify.com/api/token",
                        body: body, headers: headers, format: :json)
    response_body = JSON.parse(res.body)
    puts "IN AUTHORIZE, RESPONSE BODY: #{ response_body }"
    self.access_token = response_body["access_token"]
    self.refresh_token = response_body["refresh_token"]
    return res
  end

  def self.authorized?
    return !access_token.blank?
  end
end