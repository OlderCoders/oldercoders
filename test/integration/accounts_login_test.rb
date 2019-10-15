require 'test_helper'

class AccountsLoginTest < ActionDispatch::IntegrationTest

  def setup
    @account             = accounts(:michael)
    @account_no_username = accounts(:umberto)
    @account_inactive    = accounts(:igor)
  end

  test "login with valid information followed by logout" do
    get new_account_session_url
    assert_template 'sessions/new'
    sign_in_as @account
    assert account_signed_in?
    assert_redirected_to root_url
    follow_redirect!
    sign_out_as @account
    assert_not account_signed_in?
    assert_redirected_to root_url
  end

  test "login with valid information without having a username set up" do
    get new_account_session_url
    assert_template 'sessions/new'
    sign_in_as @account_no_username
    assert_nil @account_no_username.username
    assert account_signed_in?
    # Should be redirected to profile creation
    assert_redirected_to new_username_path
    follow_redirect!
    assert_template 'accounts/usernames/new'
  end

  test "login as an inactive account" do
    get new_account_session_url
    assert_template 'sessions/new'
    sign_in_as @account_inactive
    assert_not account_signed_in?
    assert_not flash.empty?
    assert_equal flash[:alert], I18n.t('devise.failure.unconfirmed')
  end

  test "login with remembering" do
    sign_in_as @account, remember_me: '1'
    assert_in_delta @account.reload.remember_created_at, Time.zone.now, 1.second
  end

  test "login without remembering" do
    sign_in_as @account, remember_me: '0'
    assert_nil @account.reload.remember_created_at
  end

end
