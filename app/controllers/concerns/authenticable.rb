module Authenticable

  # Devise methods overwrites
  def current_user
    @current_user ||= User.joins(:user_authentication_tokens).where('user_authentication_tokens.token = ? AND user_authentication_tokens.expires_at > ?', request.headers['Authorization'], DateTime.now.beginning_of_day).first
    
    @current_user
  end

  def authenticate_with_token!
    render json: { errors: "Not authenticated" },
                status: :unauthorized unless user_signed_in?
  end

  def user_signed_in?
    current_user.present?
  end
end