class Account < ApplicationRecord
  include TranslateEnum
  include Tokenable
  include Activatable
  include Digestable
  include Friendable

  enum role: {
    user:      0,
    admin:     1,
    disabled:  2,
  }
  translate_enum :role

  has_person_name

  has_one  :profile, class_name: 'Account::Profile', inverse_of: :account, foreign_key: 'account_id', dependent: :destroy

  before_save          :sanitize_inputs
  before_save          :clean_username
  before_validation    :clean_email
  # after_validation     :move_friendly_id_error_to_username

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

  validates :new_email,
            length: { maximum: 255 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL },
            allow_blank: true,
            new_email_unique: true

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Clears out pending email changes
  def destroy_email_change_token
    self.email_confirmation_token = nil
    update(
      new_email: nil,
      email_confirmation_digest: nil,
      email_confirmation_sent_at: nil
    )
    reload
  end

  # Confirms a pending email update if there's a new_email value
  # by promoting that value to self.email
  def confirm_pending_email_change
    return if new_email.nil?

    update email: new_email
    destroy_email_change_token
  end

  private

    def clean_username
      self.username = username.strip.downcase if username.present?
    end

    def clean_email
      self.email = email.downcase.strip if email.present?
      self.new_email = new_email.downcase.strip if new_email.present?
    end

    def create_email_confirmation_token
      self.email_confirmation_token = new_token
      update email_confirmation_digest: digest(email_confirmation_token)
    end

end
