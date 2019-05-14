class Account::Profile < ApplicationRecord
  def self.table_name_prefix
    'account_'
  end

  before_save :sanitize_inputs
  before_validation :verify_twitter_username, :verify_github_username

  belongs_to :account, inverse_of: :profile, foreign_key: 'account_id', touch: true

  validate :birthday_should_within_age_range
  validate :coding_since_should_not_be_earlier_than_birthday

  validates :birthday, presence: true, on: :update
  validates :location, length: { maximum: 128 }
  validates :bio, length: { maximum: 255 }
  validates :twitter_username,
            length: { maximum: 128 },
            format: /\A\w+\Z/,
            uniqueness: { allow_nil: true },
            if: :twitter_username_changed?
  validates :github_username,
            length: { maximum: 128 },
            format: /\A[A-Za-z0-9\-]+\Z/,
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

    def coding_since_should_not_be_earlier_than_birthday
      return if birthday.blank? or coding_since.blank?

      errors.add(:coding_since, 'can\'t be before your birthday') if birthday.beginning_of_year > coding_since.beginning_of_year
    end

    def verify_twitter_username
      if twitter_username.blank?
        self.twitter_username = nil
        return
      end
      self.twitter_username = twitter_username.squish.delete '@'
    end

    def verify_github_username
      if github_username.blank?
        self.github_username = nil
        return
      end
      self.github_username = github_username.squish.delete '@'
    end
end
