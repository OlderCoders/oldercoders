module Activatable
  extend ActiveSupport::Concern

  include Digestable

  def activate
    update activated: true, activated_at: Time.zone.now
  end

  def send_activation_email(new_activation_token = false)
    if new_activation_token == true
      create_activation_token
      update activation_digest: digest(activation_token)
      reload
    end
    # AccountMailer.account_activation(self).deliver_now
  end

  private

    def create_activation_token
      self.activation_token = new_token
      self.activation_digest = digest(activation_token)
    end

end
