module RequestedAccount
  extend ActiveSupport::Concern

  included do
    before_action :find_account
  end

  private

    def find_account
      @account = Account.find_by!(username: params[:username])
    end

end
