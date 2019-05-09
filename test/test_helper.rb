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

  # Returns true if a test user is logged in.
  def is_logged_in?
    session.key?(:user_id)
  end

  # Log in as a particular user.
  def log_in_as(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete :user_id
  end

  def current_user
    Account.find(session[:user_id]) || @account
  end

end

class ActionDispatch::IntegrationTest
  def teardown
    log_out
  end

  # Log in as a particular user.
  def log_in_as(user, *args)
    options = args.extract_options!
    password = options[:password] || 'password'
    remember = options[:remember] || '1'

    post login_path, params: {
      session: {
        email: user.email,
        password: password,
        remember: remember
      }
    }
  end

  def log_out
    get logout_path
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
