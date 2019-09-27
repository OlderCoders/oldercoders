class ApplicationController < ActionController::Base
  prepend_view_path Rails.root.join("frontend")

  include Authenticatable
  include CurrentAccount
  include EnforceAccountProfile
  include Errorable
  include UnobtrusiveJavascriptable

end
