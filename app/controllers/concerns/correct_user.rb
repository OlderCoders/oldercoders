module CorrectUser
  extend ActiveSupport::Concern
  include RequestedUser

  included do
    before_action :correct_user, except: :show
  end

  # Confirms that the user is only accessing their own stuff
  def correct_user
    logged_in_user and return unless logged_in?
    find_account if @user.blank?
    redirect_to_current_user unless current_user? @user
  end

end
