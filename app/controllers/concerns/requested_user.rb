module RequestedUser
  extend ActiveSupport::Concern

  included do
    before_action :find_user
  end

  private

    def find_user
      @user = User.find_by!(username: params[:username])
    end

end
