module Tokenable
  extend ActiveSupport::Concern

  def new_token
    self.class.new_token
  end

  module ClassMethods
    def new_token
      SecureRandom.urlsafe_base64(16)
    end
  end

end
