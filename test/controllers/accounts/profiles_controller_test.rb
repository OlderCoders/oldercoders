require 'test_helper'

class Accounts::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @account = accounts(:michael)
    @other_account = accounts(:hugh)
  end

  test 'edit profile route should redirect to login when not logged in' do
    get edit_profile_url username: @account.username
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'edit profile route should redirect to logged in account profile when you try to access a different account edit page' do
    log_in_as @account
    get edit_profile_url username: @other_account.username
    assert_redirected_to account_url username: @account.username
  end

  test 'edit profile route should load successfully for a logged in account with a profile' do
    log_in_as @account
    get edit_profile_url username: @account.username
    assert_template 'accounts/profiles/edit'
    assert_response :success
  end

  test 'should redirect update profile when not logged in' do
    patch profile_path(username: @account.username), params: {
      account_profile: {
        bio: 'testing the bits and pieces',
        location: 'the french riveria',
        website_url: 'https://winecountry.com'
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'update profile route should redirect to logged in account profile when you try to update a different account\'s profile' do
    log_in_as @account
    data = {
      bio: 'testing the bits and pieces',
      location: 'the french riveria',
      website_url: 'https://winecountry.com'
    }
    patch profile_path(username: @other_account.username), params: {
      account_profile: data
    }
    assert_redirected_to account_url username: @account.username
    assert_not_equal data[:bio], @other_account.profile.bio
    assert_not_equal data[:location], @other_account.profile.location
    assert_not_equal data[:website_url], @other_account.profile.website_url
  end

  test 'should display validation errors when editing profile with invalid data' do
    log_in_as @account
    data = {
      bio: 'a' * 500,
      location: 'b' * 500,
      website_url: 'foo'
    }
    patch profile_path(username: @account.username), params: {
      account_profile: data
    }
    account = assigns :account
    assert_not account.profile.valid?
    assert_template 'accounts/profiles/edit'
  end

  test 'should update profile when editing as a logged in account' do
    log_in_as @account
    data = {
      bio: 'testing the bits and pieces',
      location: 'the french riveria',
      website_url: 'https://winecountry.com'
    }
    patch profile_path(username: @account.username), params: {
      account_profile: data
    }
    assert_equal data[:bio],         @account.profile.bio
    assert_equal data[:location],    @account.profile.location
    assert_equal data[:website_url], @account.profile.website_url
    assert_not flash.empty?
    assert_redirected_to account_url(username: @account.username)
  end

end
