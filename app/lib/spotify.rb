class Spotify
  cattr_accessor :api_base, :redirect_uri, :client_id, :client_secret, :scope
  @@api_base = "https://api.spotify.com/v1/"
  @@redirect_uri = "http://localhost:3000/admin/callback"
  @@client_id =  "ce70d352f84d4beca810a20ad97b26de"
  @@client_secret = "84519bd0a95b41f6b763ce947ebff32b"
  @@scope = "playlist-read-private playlist-modify-private user-read-currently-playing"

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

  def self.authorize(auth_code)
    body = {
      code: auth_code,
      redirect_uri: redirect_uri,
      grant_type: "authorization_code",
      client_id: client_id,
      client_secret: client_secret
    }
    res = HTTParty.post("https://accounts.spotify.com/api/token",
                        body: body, format: :json)
    body = res.body
    self.access_token = res.body["access_token"]
    self.refresh_token = res.body["refresh_token"]
    return true
  end

  def self.authorized?
    return !access_token.blank?
  end
end