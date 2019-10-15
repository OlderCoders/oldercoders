class Account < ApplicationRecord
  include TranslateEnum
  include Friendable

  enum role: {
    user: 0,
    admin: 1,
    disabled: 2
  }
  translate_enum :role

  has_person_name

  has_one :profile, class_name: 'Account::Profile', inverse_of: :account, foreign_key: 'account_id', dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  VALID_USERNAME = /\A\w+\Z/.freeze # Case insensitive match a-z, 0-9 and underscores
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze

  validates :first_name, length: { maximum: 255 }
  validates :last_name, length: { maximum: 255 }
  validates :first_name, presence: true, unless: :new_record?
  validates :last_name, presence: true, unless: :new_record?

  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            format: { with: VALID_EMAIL }

  validates :username,
            presence: true,
            allow_nil: true,
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_USERNAME },
            not_reserved_word: { field: :username }

  validate :password_should_not_equal_email_or_username

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
      self.unconfirmed_email = unconfirmed_email.downcase.strip if unconfirmed_email.present?
    end

    def password_should_not_equal_email_or_username
      return unless password.present? &&
                    ((email.present? && password.casecmp(email).zero?) ||
                    (username.present? && password.casecmp(username).zero?))

      errors.add(:password, I18n.t('errors.messages.password.as_account_id'))
    end

end
