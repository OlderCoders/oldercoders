class SessionsController < ApplicationController

  before_action :logged_in_account, only: [:destroy]

  def new
    respond_to do |format|
      format.json { render json: { redirect_to: login_url } }
      format.html { render }
    end
  end

  def create
    @account = Account.find_by(email: login_params[:email].downcase)
    invalid_account and return if @account.blank?
    unactivated_account and return unless @account.activated?
    invalid_account and return unless @account.authenticate(login_params[:password])

    # If we're here, we've got valid credentials for an active account.
    log_in @account
    login_params[:remember] == '1' ? remember(@account) : forget(@account)
    # Does the account have a username set up?
    if @account.username.blank?
      flash[:notice] = t('.create_username', name: @account.name)
      redirect_to new_username_path and return
    end
    redirect_back_or account_path(username: @account.username)
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def login_params
      params.require(:session).permit(:email, :password, :remember)
    end

    def invalid_account
      @account = Account.new
      @account.errors.add(:base, t('.incorrect_credentials'))
      render 'new'
    end

    def unactivated_account
      @error_header = t('.account_not_activated')
      @account.errors.add(:base, t('.resend_activation', link: resend_account_activation_path(@account.id)))
      render 'new'
    end

end
