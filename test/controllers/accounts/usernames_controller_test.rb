require 'test_helper'

class Accounts::UsernamesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user         = accounts(:michael)
    @other_user   = accounts(:hugh)
    @usernameless = accounts(:umberto)
  end

  test 'new username route should redirect to login when not logged in' do
    get new_username_url
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'logged in user without a username can get to the new username page' do
    log_in_as @usernameless
    get new_username_url
    assert_response :success
    assert_template 'accounts/usernames/new'
  end

  test 'logged in user with a username should get redirected to the account edit page' do
    log_in_as @user
    get new_username_url
    assert_redirected_to user_url username: @user.username
  end

  test 'should redirect update username when not logged in' do
    patch username_path, params: {
      account: {
        username: 'batman'
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should not set new username when patching the update username with an existing username when logged in' do
    log_in_as @usernameless
    assert_nil @usernameless.username
    patch username_path, params: {
      account: {
        username: @user.username
      }
    }
    assert_nil @usernameless.reload.username
    assert_template 'accounts/usernames/new'
  end

  test 'should set new username when patching the update username when logged in without a username' do
    log_in_as @usernameless
    assert_nil @usernameless.username
    patch username_path, params: {
      account: {
        username: 'batman'
      }
    }
    assert_not flash.empty?
    assert_equal 'batman', @usernameless.reload.username
  end

  test 'should redirect to choose username when navigating to any other page on the site as a profileless user' do
    log_in_as @usernameless
    assert_redirected_to new_username_url
    get user_path username: @user.username
    assert_redirected_to new_username_url
  end
end
