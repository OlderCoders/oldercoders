class Accounts::RelationshipsController < ApplicationController

  include RequestedAccount

  before_action :logged_in_account

  # GET
  # account_following
  #
  # The view for seeing who a account is following
  # def following
  #   @accounts = @account.following.page(params[:page])
  #   respond_to do |format|
  #     format.json.ujs  { render 'index', layout: false }
  #     format.html      { render 'following' }
  #   end
  # end

  # GET
  # account_followers
  #
  # The view for seeing a list of a account's followers
  # def followers
  #   @accounts = @account.followers.page(params[:page])
  #   respond_to do |format|
  #     format.json.ujs  { render 'index', layout: false }
  #     format.html      { render 'followers' }
  #   end
  # end

  # POST
  # follow
  #
  # Sets up a following/follower relationship
  def create
    current_account.follow(@account)
    # TODO: Set up a mailer for notifying accounts of new followers
    respond_to do |format|
      format.html { redirect_to account_url }
      format.json { render :status }
    end

  end

  # DELETE
  # unfollow
  #
  # Deletes a following/follower relationship
  def destroy
    current_account.unfollow(@account)
    respond_to do |format|
      format.html { redirect_to account_url }
      format.json { render :status }
    end
  end
end
