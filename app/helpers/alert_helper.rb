module AlertHelper
  # Pulls displayable alerts out of the flash object
  def alerts
    items = []
    notification_types = %w[warning notice error]
    flash.each do |message_type, message|
      next unless notification_types.include?(message_type) and message.present?
      items << { type: message_type, message: message.html_safe }
    end
    items
  end
end
