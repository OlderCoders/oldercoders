module Friendable
  extend ActiveSupport::Concern

  included do
    has_many :active_relationships,
             class_name: 'Relationship',
             inverse_of: :follower,
             foreign_key: 'follower_id',
             dependent: :destroy

    has_many :passive_relationships,
             class_name: 'Relationship',
             inverse_of: :followee,
             foreign_key: 'followee_id',
             dependent: :destroy

    has_many :following, through: :active_relationships,  source: :followee
    has_many :followers, through: :passive_relationships, source: :follower
  end

  def follow(other_user)
    return if following? other_user
    following << other_user
    # TODO - notify followed user, via mail and notificaiton mechanism
  end

  def unfollow(other_user)
    following.delete other_user
    other_user.touch
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.pluck(:id).include? other_user.id
  end

  # "Friends" are mutual followers, a bidirectional follower relationship between two users.
  def friend_ids
    query = self.class.friend_ids_query(id)
    @friend_ids ||= self.class.connection.exec_query(query).rows.flatten
  end


  module ClassMethods
    def friend_ids(account_id)
      query = friend_ids_query(account_id)
      connection.exec_query(query).rows.flatten
    end

    def friend_ids_query(account_id)
      %(
        SELECT     accounts.id
        FROM       accounts
        INNER JOIN relationships followers ON accounts.id = followers.follower_id
        INNER JOIN relationships followed ON accounts.id = followed.followee_id
        WHERE      followers.followee_id = #{account_id} AND followed.follower_id = #{account_id}
        ORDER BY   followed.updated_at DESC;
      ).squish
    end
  end

end
