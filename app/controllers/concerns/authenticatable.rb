module Authenticatable
  extend ActiveSupport::Concern

  included do
  end

  # Logs in the given user
  def log_in(user)
    if session.present?
      old_session_values = session.to_hash
      reset_session
      session.update(old_session_values)
    end
    session[:user_id] = user.id
  end

  # Logs the current user out
  def log_out
    forget(current_user)
    @current_user = nil
    return if session.blank?
    session.delete(:user_id)
    session.delete(:forwarding_url) # In case a user didn't end up at their forwarding URL in this session
    reset_session
  end

  # Remembers the user in a persistent session
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Properly negate all aspects of a user's remember cookie
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
