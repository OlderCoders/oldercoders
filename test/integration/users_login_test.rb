require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = accounts(:michael)
    @user_no_username = accounts(:umberto)
    @user_inactive   = accounts(:igor)
  end

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: "",
        password: ""
      }
    }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_select '.form-errors'
  end

  test "login with valid information followed by logout" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: @user.email,
        password: "password"
      }
    }
    assert is_logged_in?
    assert_redirected_to user_path(username: @user.username)
    follow_redirect!
    assert_template 'users/show'
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    # Simulate a user clicking logout in a second window.
    delete logout_path
    follow_redirect!
    # TODO: Assert select logged out state items on home page
  end

  test "login with valid information without having a username set up" do
    get login_path
    assert_template 'sessions/new'
    log_in_as @user_no_username
    assert_nil @user_no_username.username
    assert is_logged_in?
    # Should be redirected to profile creation
    assert_redirected_to new_username_path
    follow_redirect!
    assert_template 'accounts/usernames/new'
    assert_not flash.empty?
  end

  test "login as an inactive user" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: {
      session: {
        email: @user_inactive.email,
        password: 'password'
      }
    }
    assert_not is_logged_in?
    assert_template 'sessions/new'
    assert_select '.form-errors h4', I18n.t('sessions.create.account_not_activated')
  end

  test "login with remembering" do
    log_in_as(@user, remember: '1')
    assert_equal @user.reload.remember_digest, assigns(:user).remember_digest
  end

  test "login without remembering" do
    log_in_as(@user, remember: '0')
    assert_nil cookies['remember_token']
  end

end
