require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase

  def setup
    @account_michael = accounts(:michael)
    @account_hugh    = accounts(:hugh)
    @account_igor    = accounts(:igor)
    @relationship = Relationship.new(follower_id: @account_michael.id,
                                     followee_id: @account_hugh.id)
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
    @account_michael.follow @account_igor
    @account_igor.follow @account_michael
    # Validate relationships
    assert @account_michael.following? @account_igor
    assert @account_igor.following? @account_michael
    # Instance Methods
    assert @account_michael.reload.friend_ids.include? @account_igor.id
    assert @account_igor.reload.friend_ids.include? @account_michael.id
    # Class Methods
    assert Account.friend_ids(@account_michael.id).include? @account_igor.id
    assert Account.friend_ids(@account_igor.id).include? @account_michael.id
  end

  test "friend_ids should not include ids of non-mutual followers" do
    # Set up a one sided relationship
    @account_michael.follow @account_igor
    @account_igor.unfollow @account_michael
    # Validate relationships
    assert @account_michael.following? @account_igor
    assert_not @account_igor.following? @account_michael
    # Instance Methods
    assert_not @account_michael.reload.friend_ids.include? @account_igor.id
    assert_not @account_igor.reload.friend_ids.include? @account_michael.id
    # Class Methods
    assert_not Account.friend_ids(@account_michael.id).include? @account_igor.id
    assert_not Account.friend_ids(@account_igor.id).include? @account_michael.id
  end

end
