module Errorable
  extend ActiveSupport::Concern

  included do
    NotAuthorized = Class.new(StandardError)

    rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound do |exception|
      render_error_page status: 404, text: 'Page Not Found', template: 'not_found'
    end

    rescue_from ApplicationController::NotAuthorized do |exception|
      render_error_page status: 401, text: 'Unauthorized', template: 'unauthorized'
    end
  end

  def raise_not_found(msg = 'Page Not Found')
    raise ActionController::RoutingError.new msg
  end

  def raise_unauthorized(msg = 'Unauthorized')
    raise ApplicationController::NotAuthorized.new msg
  end

  private

    def render_error_page(status:, text:, template:)
      template = "system/errors/#{template}"
      respond_to do |format|
        format.json { render json: {errors: [message: "#{status} #{text}"]}, status: status }
        format.html { render template: template, layout: 'application', status: status }
        format.any  { head status }
      end
    end

end
