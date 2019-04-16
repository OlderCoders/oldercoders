require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @user_michael = accounts(:michael)
    @user_hugh    = accounts(:hugh)
    @user_igor    = accounts(:igor)
    @relationship = Relationship.new(follower_id: @user_michael.id,
                                     followee_id: @user_hugh.id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a followee_id" do
    @relationship.followee_id = nil
    assert_not @relationship.valid?
  end

  test "friend_ids should include ids of mutual followers" do
    # Set up a mutual relationship
    @user_michael.follow @user_igor
    @user_igor.follow @user_michael
    # Validate relationships
    assert @user_michael.following? @user_igor
    assert @user_igor.following? @user_michael
    # Instance Methods
    assert @user_michael.reload.friend_ids.include? @user_igor.id
    assert @user_igor.reload.friend_ids.include? @user_michael.id
    # Class Methods
    assert User.friend_ids(@user_michael.id).include? @user_igor.id
    assert User.friend_ids(@user_igor.id).include? @user_michael.id
  end

  test "friend_ids should not include ids of non-mutual followers" do
    # Set up a one sided relationship
    @user_michael.follow @user_igor
    @user_igor.unfollow @user_michael
    # Validate relationships
    assert @user_michael.following? @user_igor
    assert_not @user_igor.following? @user_michael
    # Instance Methods
    assert_not @user_michael.reload.friend_ids.include? @user_igor.id
    assert_not @user_igor.reload.friend_ids.include? @user_michael.id
    # Class Methods
    assert_not User.friend_ids(@user_michael.id).include? @user_igor.id
    assert_not User.friend_ids(@user_igor.id).include? @user_michael.id
  end

end
