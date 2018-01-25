class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def require_token
    if params[:_token] != ENV["access_token"]
      render file: File.join(Rails.root, 'public/404'), formats: [:html], status: 404, layout: false
    end
  end
end
