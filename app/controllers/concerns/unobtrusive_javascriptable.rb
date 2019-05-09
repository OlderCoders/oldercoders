module UnobtrusiveJavascriptable
  extend ActiveSupport::Concern

  included do
    before_action :set_request_variant
  end

  private

    def set_request_variant
      request.variant = :ujs if request.headers['X-Requested-By'] == 'UJS'
    end

end
