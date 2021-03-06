class Accounts::ProfilesController < ApplicationController

  before_action :current_account_as_account
  before_action :logged_in_account

  def edit
  end

  def update
    @account.profile.update(account_profile_params)
    if current_account.profile.valid?
      unless current_account.errors.any?
        flash[:notice] = t('.has_been_updated')
        redirect_to account_url(username: current_account.username) and return
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
