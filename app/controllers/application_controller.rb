class ApplicationController < ActionController::Base
  prepend_view_path Rails.root.join("frontend")

  include Authenticatable
  include CurrentUser
  include EnforceUserProfile
  include Errorable

end
