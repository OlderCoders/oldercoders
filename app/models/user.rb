class User < Account
  include Rememberable

  attr_accessor :activation_token, :reset_token
  attr_reader :old_password

  before_create :create_activation_token

  validates :email,
            presence: :true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 255 },
            format: { with: VALID_EMAIL }

  has_secure_password validations: false
  # The has_secure_password methods dictate a maximum length of 72 characters
  validates :password, presence: true, length: (10..72), confirmation: true, allow_nil: true
  validate :password_should_not_equal_email_or_username

  #
  # Scopes
  #

  #
  # Instance Methods
  #
  def destroy_reset_token
    self.reset_token = nil
    update reset_digest: nil, reset_sent_at: nil
  end


  private

    def create_activation_token
      self.activation_token = new_token
      self.activation_digest = digest(activation_token)
    end

    def password_should_not_equal_email_or_username
      return unless password.present? &&
                    ((email.present? && password.casecmp(email).zero?) ||
                    (username.present? && password.casecmp(username).zero?))
      errors.add(:password, I18n.t('errors.messages.password.as_user_id'))
    end

end
