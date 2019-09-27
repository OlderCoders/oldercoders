module CorrectAccount
  extend ActiveSupport::Concern
  include RequestedAccount

  included do
    before_action :correct_account, except: :show
  end

  # Confirms that the account is only accessing their own stuff
  def correct_account
    logged_in_account and return unless logged_in?
    find_account if @account.blank?
    redirect_to_current_account unless current_account? @account
  end

end
