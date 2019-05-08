class Accounts::RelationshipsController < ApplicationController

  include RequestedUser

  before_action :logged_in_user

  # GET
  # account_following
  #
  # The view for seeing who a user is following
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
  # The view for seeing a list of a user's followers
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
    current_user.follow(@user)
    # TODO: Set up a mailer for notifying users of new followers
    respond_to do |format|
      format.html { redirect_to user_url }
      format.js   { render :status }
      format.json { render :status }
    end

  end

  # DELETE
  # unfollow
  #
  # Deletes a following/follower relationship
  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to user_url }
      format.js   { render :status }
      format.json { render :status }
    end
  end
end
