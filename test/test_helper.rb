ENV['RAILS_ENV'] ||= 'test'

if ENV['RAILS_ENV'] == 'test' and ENV['CODE_COVERAGE'] == 'true'
  require 'simplecov'
  SimpleCov.start 'rails'
  puts "required simplecov"
end

require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase

  # Run tests in parallel with specified workers
  # NOTE:
  # Simplecov misreports coverage when running parallelized tests.
  # see https://github.com/colszowka/simplecov/issues/718

  parallelize(workers: :number_of_processors) unless ENV['CODE_COVERAGE'] == 'true'

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def logout
    session.delete :account_id
  end

  def current_account
    Account.find(session[:account_id]) || @account
  end

end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  # def teardown
  #   for account in Account.all
  #     sign_out account
  #   end
  # end

  # Log in as a particular account.
  def sign_in_as(account, *args)
    options = args.extract_options!
    password = options[:password] || 'password'
    remember_me = options[:remember_me] || '1'

    post account_session_path, params: {
      account: {
        email: account.email,
        password: password,
        remember_me: remember_me
      }
    }
  end

  def sign_out_as(account)
    delete destroy_account_session_path
  end

  def account_signed_in?
    controller.respond_to? :current_account and controller.current_account.present?
  end

  def ujs_request
    {
      as: :json,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-Requested-By': 'UJS'
      }
    }
  end
end

# Sampled from http://approache.com/blog/testing-rails-across-time-zones/
module TimeZoneHelper
  def self.random_time_zone
    offsets = ActiveSupport::TimeZone.all.group_by(&:formatted_offset)
    zones = offsets[offsets.keys.sample]
    zones.sample.name
  end
end
