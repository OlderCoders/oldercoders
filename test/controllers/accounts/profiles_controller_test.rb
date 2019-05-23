require 'test_helper'

class Accounts::ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = accounts(:michael)
    @other_user = accounts(:hugh)
  end

  test 'edit profile route should redirect to login when not logged in' do
    get edit_profile_url username: @user.username
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'edit profile route should redirect to logged in user profile when you try to access a different user edit page' do
    log_in_as @user
    get edit_profile_url username: @other_user.username
    assert_redirected_to user_url username: @user.username
  end

  test 'edit profile route should load successfully for a logged in user with a profile' do
    log_in_as @user
    get edit_profile_url username: @user.username
    assert_template 'accounts/profiles/edit'
    assert_response :success
  end

  test 'should redirect update profile when not logged in' do
    patch profile_path(username: @user.username), params: {
      account_profile: {
        bio: 'testing the bits and pieces',
        location: 'the french riveria',
        website_url: 'https://winecountry.com'
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'update profile route should redirect to logged in user profile when you try to update a different user\'s profile' do
    log_in_as @user
    data = {
      bio: 'testing the bits and pieces',
      location: 'the french riveria',
      website_url: 'https://winecountry.com'
    }
    patch profile_path(username: @other_user.username), params: {
      account_profile: data
    }
    assert_redirected_to user_url username: @user.username
    assert_not_equal data[:bio], @other_user.profile.bio
    assert_not_equal data[:location], @other_user.profile.location
    assert_not_equal data[:website_url], @other_user.profile.website_url
  end

  test 'should display validation errors when editing profile with invalid data' do
    log_in_as @user
    data = {
      bio: 'a' * 500,
      location: 'b' * 500,
      website_url: 'foo'
    }
    patch profile_path(username: @user.username), params: {
      account_profile: data
    }
    user = assigns :user
    assert_not user.profile.valid?
    assert_template 'accounts/profiles/edit'
  end

  test 'should update profile when editing as a logged in user' do
    log_in_as @user
    data = {
      bio: 'testing the bits and pieces',
      location: 'the french riveria',
      website_url: 'https://winecountry.com'
    }
    patch profile_path(username: @user.username), params: {
      account_profile: data
    }
    assert_equal data[:bio],         @user.profile.bio
    assert_equal data[:location],    @user.profile.location
    assert_equal data[:website_url], @user.profile.website_url
    assert_not flash.empty?
    assert_redirected_to user_url(username: @user.username)
  end

end
