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

  # Returns true if a test account is logged in.
  def is_logged_in?
    session.key?(:account_id)
  end

  # Log in as a particular account.
  def sign_in_as(account)
    session[:account_id] = account.id
  end

  def logout
    session.delete :account_id
  end

  def current_account
    Account.find(session[:account_id]) || @account
  end

end

class ActionDispatch::IntegrationTest
  def teardown
    sign_out
  end

  # Log in as a particular account.
  def sign_in_as(account, *args)
    options = args.extract_options!
    password = options[:password] || 'password'
    remember = options[:remember] || '1'

    post account_session_path, params: {
      session: {
        email: account.email,
        password: password,
        remember: remember
      }
    }
  end

  def sign_out
    delete destroy_account_session_url
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
