class Account < ApplicationRecord
  include TranslateEnum
  include Tokenable
  include Digestable
  include Friendable

  enum role: {
    user:      0,
    admin:     1,
    disabled:  2,
  }
  translate_enum :role

  has_person_name

  has_one :profile, class_name: 'Account::Profile', inverse_of: :account, foreign_key: 'account_id', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  VALID_ACCOUNT_TYPES = %w[User].freeze
  VALID_USERNAME = /\A\w+\Z/.freeze # Case insensitive match a-z, 0-9 and underscores
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :first_name, presence: true, length: { maximum: 255 }
  validates :last_name, presence: true, length: { maximum: 255 }

  validates :type, inclusion: { in: VALID_ACCOUNT_TYPES }

  validates :username,
            presence: true,
            allow_nil: true,
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_USERNAME },
            not_reserved_word: { field: :username }

  before_save          :sanitize_inputs
  before_save          :clean_username
  before_validation    :clean_email
  after_create         :create_profile

  private

    def clean_username
      self.username = username.strip.downcase if username.present?
    end

    def clean_email
      self.email = email.downcase.strip if email.present?
    end

end
