require 'test_helper'

class RelationshipsTest < ActionDispatch::IntegrationTest

  def setup
    @account = accounts(:michael)
    @other   = accounts(:user_5) # :michael doesn't have a predefined relationship with user_5
  end

  test "following page as a logged out user" do
    get following_path(username: @account.username)
    assert_not @account.following.empty?
    assert_match @account.following.count.to_s, response.body
    @account.following.each do |user|
      assert_select "a[href=?]", account_url(username: user.username)
    end
    assert_select ".pagination.pagination--incremental"
  end

  test "followers page as a logged out user" do
    get followers_path(username: @account.username)
    assert_not @account.followers.empty?
    assert_match @account.followers.count.to_s, response.body
    @account.followers.each do |user|
      assert_select "a[href=?]", account_url(username: user.username)
    end
    assert_select ".pagination.pagination--incremental"
  end

  test "should follow a user the standard way" do
    sign_in_as @account
    assert_difference '@account.following.count', 1 do
      post relationship_path(username: @other.username)
    end
  end

  test "should follow a user with Ajax" do
    sign_in_as @account
    assert_difference '@account.following.count', 1 do
      post relationship_path(username: @other.username), xhr: true
    end
  end

  test "should unfollow a user the standard way" do
    sign_in_as @account
    @account.follow(@other)
    assert_difference '@account.following.count', -1 do
      delete relationship_path(username: @other.username)
    end
  end

  test "should unfollow a user with Ajax" do
    sign_in_as @account
    @account.follow(@other)
    assert_difference '@account.following.count', -1 do
      delete relationship_path(username: @other.username), xhr: true
    end
  end

end
