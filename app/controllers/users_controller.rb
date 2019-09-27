class AccountsController < ApplicationController
  include RequestedAccount

  before_action :logged_in_account, except: %i[show]
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
