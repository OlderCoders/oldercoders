module CurrentAccount
  extend ActiveSupport::Concern

  included do
  end

  # Returns true if the given account is the current account.
  def current_account?(account)
    account == current_account
  end

  def current_account_id_included?(account_ids)
    return false unless logged_in?
    account_ids = [account_ids] unless account_ids.is_a? Array
    account_ids.include? current_account.id
  end

  def current_account_id
    return nil unless logged_in?
    current_account.id
  end

  # Sets the currently logged in account as @account
  def current_account_as_account
    @account = current_account
  end

  # Sets the currently logged in account as @account
  def current_account_as_account
    @account = current_account if current_account.is_a? Account
  end

  # Redirects to the current account.
  def redirect_to_current_account
    redirect_to account_url(username: current_account.username) and return unless current_account.username.blank?
    redirect_to new_username_url
  end

  # Returns true if the account is logged in, false otherwise.
  def logged_in?
    account_signed_in?
  end

  # Confirms that the account is logged in
  def logged_in_account
    return if logged_in?
    session[:forwarding_url] = request.original_url if request.get?
    flash[:error] = t('sessions.please_log_in')
    redirect_to login_url
  end

  # Confirms that the account is *not* logged in (Redirects to their profile page if they are.)
  def logged_out_account
    redirect_to_current_account if logged_in?
  end

  # Returns true if the account is logging out, false otherwise.
  def logging_out?
    current_account.present? && controller_name == 'sessions' && action_name == 'destroy'
  end

  # Whether or not @account is the current account
  def current_account_profile?(account = @account)
    logged_in? && current_account?(account)
  end

  # Returns true if the account is logged in and has a username set, false otherwise.
  def current_account_has_username?
    logged_in? && current_account.username.present?
  end
end
