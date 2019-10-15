class NewEmailUniqueValidator < ActiveModel::Validator

  # Ensures that the new email a account enters isn't already associated with another account
  def validate(record)
    return if new_email_is_unique(record)
    record.errors.add(
      :email,
      I18n.t('account.email.errors.not_unique')
    )
  end

  private

    def new_email_is_unique(record)
      return true if record.new_email.blank?
      record.class.find_by(email: record.new_email.downcase).nil?
    end
end
