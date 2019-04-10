module Rememberable
  extend ActiveSupport::Concern

  include Digestable

  included do
    attr_accessor :remember_token
  end

  def remember
    self.remember_token = new_token
    update remember_digest: digest(remember_token)
  end

  def forget
    update remember_digest: nil
  end
end
