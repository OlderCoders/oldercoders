class Accounts::ProfilesController < ApplicationController

  include CorrectUser

  before_action :logged_in_user
  before_action :current_account_profile?

  def edit
  end

  def update
    @user.profile.update(account_profile_params)
    if @user.profile.valid?
      unless @user.errors.any?
        flash[:notice] = t('.has_been_updated')
        redirect_to user_url and return
      end
    end
    render 'edit'
  end

  private

    def account_profile_params
      params
        .require(:account_profile)
        .permit(
          :birthday,
          :display_age,
          :coding_since,
          :location,
          :bio,
          :twitter_username,
          :github_username,
          :website_url,
          :employer_url,
          :facebook_url,
          :stackoverflow_url,
          :behance_url,
          :linkedin_url,
          :dribbble_url,
          :medium_url,
          :gitlab_url
        )
    end
end
