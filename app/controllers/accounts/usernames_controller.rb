class Accounts::UsernamesController < ApplicationController
  before_action :logged_in_user
  before_action :current_user_as_account
  before_action :usernameless_user

  # GET
  # new_username
  #
  # View to set a username
  def new
  end

  # PATCH
  # username
  #
  # Sets the username username
  def update
    @account.update(username_params)
    if @account.valid?
      flash[:notice] = t('.success')
      redirect_to user_url username: @account.username
    else
      @suppress_nav = true
      @suppress_footer = true
      render 'new'
    end
  end

  private

    def usernameless_user
      redirect_to user_url(username: @account.username) and return if @account.username.present?
    end

    def username_params
      params
        .require(:account)
        .permit(:username)
    end
end
