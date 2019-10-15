module EnforceAccountProfile
  extend ActiveSupport::Concern
  include CurrentAccount

  included do
    before_action :check_username_exists
  end

  private

    def check_username_exists
      return if logging_out?
      return unless logged_in? && current_account.username.blank? && controller_name !~ /invitations|usernames|password/
      redirect_to new_username_url
    end
end
