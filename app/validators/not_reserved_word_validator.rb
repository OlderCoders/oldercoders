class NotReservedWordValidator < ActiveModel::Validator
  def initialize(options)
    super
    @field = options[:field] || :username
  end

  # Ensures that the new email a account enters isn't already associated with another account
  def validate(record)
    return unless username_is_reserved(record)

    record.errors.add @field, I18n.t('errors.not_available')
  end

  private

    def username_is_reserved(record)
      value = record.send @field
      return false if value.blank?

      ReservedWords.all.include? value.downcase
    end
end
