require "sti_preload"

class Entry < ApplicationRecord

  include StiPreload
  include Hashid::Rails

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  has_rich_text :content

  belongs_to :author, class_name: "Account", foreign_key: "account_id"
  after_create :regenerate_slug

  validates :title, presence: true
  validates :slug, uniqueness: true

  scope :posts, -> { where(type: 'Post') }
  scope :with_author, -> { includes(:author) }

  def self.types
    Entry.descendants.map(&:name)
  end

  private

    def slug_candidates
      candidates = [:title]
      unique_id = new_record? ? SecureRandom.uuid : self.hashid
      candidates << [:title, unique_id]
    end

    def regenerate_slug
      update_column :slug, nil
      save!
    end
end
