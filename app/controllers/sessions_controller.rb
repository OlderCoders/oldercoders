class SessionsController < ApplicationController

  before_action :logged_in_user, only: [:destroy]
  before_action :logged_out_user, except: [:destroy]

  def new
    respond_to do |format|
      format.json { render json: { redirect_to: login_url } }
      format.html { render }
    end
  end

  def create
    @user = User.find_by(email: login_params[:email].downcase)
    invalid_user and return if @user.blank?
    unactivated_user and return unless @user.activated?
    invalid_user and return unless @user.authenticate(login_params[:password])

    # If we're here, we've got valid credentials for an active user.
    log_in @user
    login_params[:remember] == '1' ? remember(@user) : forget(@user)
    # Does the user have a username set up?
    if @user.username.blank?
      flash[:notice] = t('.create_username', name: @user.name)
      redirect_to new_username_path and return
    end
    redirect_back_or user_path(username: @user.username)
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

    def login_params
      params.require(:session).permit(:email, :password, :remember)
    end

    def invalid_user
      @user = User.new
      @user.errors.add(:base, t('.incorrect_credentials'))
      render 'new'
    end

    def unactivated_user
      @error_header = t('.account_not_activated')
      @user.errors.add(:base, t('.resend_activation', link: resend_account_activation_path(@user.id)))
      render 'new'
    end

end
