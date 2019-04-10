module Digestable
  extend ActiveSupport::Concern

  def digest(string)
    self.class.digest string
  end

  module ClassMethods
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end

end
