module Accounts::RelationshipsHelper

  def followers_with_count(account = @account)
    count = account.followers.count
    t(
      'accounts.relationships.stats.follower_count',
      count: count,
      human_count: number_to_human(count, precision: 1, significant: false)
    ).html_safe
  end

  def following_with_count(account = @account)
    count = account.following.count
    t(
      'accounts.relationships.stats.following_count',
      count: count,
      human_count: number_to_human(count, precision: 1, significant: false)
    ).html_safe
  end

end
