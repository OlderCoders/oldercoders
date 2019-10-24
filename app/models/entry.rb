require "sti_preload"

class Entry < ApplicationRecord

  include StiPreload
  include Hashid::Rails

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  belongs_to :author, class_name: 'Account', foreign_key: 'account_id'
  has_one :content, class_name: 'RichText', as: :record, dependent: :destroy

  validates :title, presence: true
  validates :slug, uniqueness: true

  validates_presence_of :content
  validates_associated :content

  delegate :body, :body=, :body_raw, :body_raw=, to: :content

  after_initialize :build_dependencies
  after_create :regenerate_slug

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

    def build_dependencies
      byebug
      content = self.build_content unless self.persisted?
    end

end
