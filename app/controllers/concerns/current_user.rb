module CurrentUser
  extend ActiveSupport::Concern

  included do
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  def current_user_id_included?(user_ids)
    return false unless logged_in?
    user_ids = [user_ids] unless user_ids.is_a? Array
    user_ids.include? current_user.id
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    elsif cookies.signed[:user_id]
      user = User.find_by(id: cookies.signed[:user_id])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def current_user_id
    return nil unless logged_in?
    current_user.id
  end

  # Sets the currently logged in user as @account
  def current_user_as_account
    @account = current_user
  end

  # Sets the currently logged in user as @user
  def current_user_as_user
    @user = current_user if current_user.is_a? User
  end

  # Redirects to the current user.
  def redirect_to_current_user
    redirect_to user_url(username: current_user.username) and return unless current_user.username.blank?
    redirect_to new_username_url
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end

  # Confirms that the user is logged in
  def logged_in_user
    return if logged_in?
    session[:forwarding_url] = request.original_url if request.get?
    flash[:error] = t('sessions.please_log_in')
    redirect_to login_url
  end

  # Confirms that the user is *not* logged in (Redirects to their profile page if they are.)
  def logged_out_user
    redirect_to_current_user if logged_in?
  end

  # Returns true if the user is logging out, false otherwise.
  def logging_out?
    current_user.present? && controller_name == 'sessions' && action_name == 'destroy'
  end

  # Whether or not @user is the current user
  def current_account_profile?(user = @user)
    logged_in? && current_user?(user)
  end

  # Returns true if the user is logged in and has a username set, false otherwise.
  def current_user_has_username?
    logged_in? && current_user.username.present?
  end
end
