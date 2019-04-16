class Relationship < ApplicationRecord
  # Define relationships
  belongs_to :follower, class_name: '::Account', inverse_of: :active_relationships
  belongs_to :followee, class_name: '::Account', inverse_of: :passive_relationships, touch: true

  # Validations
  validates :follower_id, presence: true
  validates :followee_id, presence: true

  # Scope
  default_scope { order(updated_at: :desc) }
end
