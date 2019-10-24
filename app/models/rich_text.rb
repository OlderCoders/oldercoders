class RichText < ApplicationRecord
  belongs_to :record, polymorphic: true
  validates :body_raw, presence: true
end
