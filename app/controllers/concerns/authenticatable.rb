module Authenticatable
  extend ActiveSupport::Concern

  included do
  end

  # Logs in the given account
  def log_in(account)
    if session.present?
      old_session_values = session.to_hash
      reset_session
      session.update(old_session_values)
    end
    session[:account_id] = account.id
  end

  # Logs the current account out
  def log_out
    forget(current_account)
    @current_account = nil
    return if session.blank?
    session.delete(:account_id)
    session.delete(:forwarding_url) # In case a account didn't end up at their forwarding URL in this session
    reset_session
  end

  # Remembers the account in a persistent session
  def remember(account)
    account.remember
    cookies.permanent.signed[:account_id] = account.id
    cookies.permanent[:remember_token] = account.remember_token
  end

  # Properly negate all aspects of a account's remember cookie
  def forget(account)
    account.forget
    cookies.delete(:account_id)
    cookies.delete(:remember_token)
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
end
