class UsersController < ApplicationController
  include RequestedUser

  before_action :logged_in_user, except: %i[show]
  before_action :current_account_profile?, except: %i[show]

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
