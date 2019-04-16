class Account::Profile < ApplicationRecord
  def self.table_name_prefix
    'account_'
  end

  before_save :sanitize_inputs
  before_validation :verify_twitter_username, :verify_github_username

  belongs_to :account, inverse_of: :profile, foreign_key: 'account_id', touch: true

  validate :birthday_should_within_age_range

  validates :birthday, presence: true
  validates :location, length: { maximum: 128 }
  validates :bio, length: { maximum: 255 }
  validates :twitter_username,
            length: { maximum: 128 },
            uniqueness: { allow_nil: true },
            if: :twitter_username_changed?
  validates :github_username,
            length: { maximum: 128 },
            uniqueness: { allow_nil: true },
            if: :github_username_changed?
  validates :website_url, :employer_url,
            length: { maximum: 128 },
            url: { allow_blank: true, no_local: true, schemes: %w[https http] }
  validates :facebook_url,
            format: /\A(http(s)?:\/\/)?(www.facebook.com|facebook.com)\/.+\Z/,
            length: { maximum: 128 },
            allow_blank: true
  validates :stackoverflow_url,
            allow_blank: true,
            length: { maximum: 128 },
            format:
            /\A(http(s)?:\/\/)?(www.stackoverflow.com|stackoverflow.com|www.stackexchange.com|stackexchange.com)\/.+\Z/
  validates :behance_url,
            allow_blank: true,
            length: { maximum: 128 },
            format: /\A(http(s)?:\/\/)?(www.behance.net|behance.net)\/.+\Z/
  validates :linkedin_url,
            allow_blank: true,
            length: { maximum: 128 },
            format:
              /\A(http(s)?:\/\/)?(www.linkedin.com|linkedin.com|[A-Za-z]{2}.linkedin.com)\/.+\Z/
  validates :dribbble_url,
            allow_blank: true,
            length: { maximum: 128 },
            format: /\A(http(s)?:\/\/)?(www.dribbble.com|dribbble.com)\/.+\Z/
  validates :medium_url,
            allow_blank: true,
            length: { maximum: 128 },
            format: /\A(http(s)?:\/\/)?(www.medium.com|medium.com)\/.+\Z/
  validates :gitlab_url,
            allow_blank: true,
            length: { maximum: 128 },
            format: /\A(http(s)?:\/\/)?(www.gitlab.com|gitlab.com)\/.+\Z/

  private

    def birthday_should_within_age_range
      return if birthday.blank?

      errors.add(:birthday, 'is too recent') if birthday > Time.zone.today - 21.years
      errors.add(:birthday, 'is too long ago. We\'re old, but come on.') if birthday < Time.zone.today - 121.years
    end

    def verify_twitter_username
      self.twitter_username = nil if twitter_username.blank?
    end

    def verify_github_username
      self.github_username = nil if github_username.blank?
    end
end
