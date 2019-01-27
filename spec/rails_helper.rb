# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'capybara/rspec'

ENV['RAILS_ENV'] ||= 'test'
#
# Require custom matchers / macros / etc.  Ruby files only - not `*._spec.rb`.
require Rails.root.join('spec/rails_support')
require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production(!!)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'

# Checks for pending migration and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = "spec/_vcr"
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

USE_VCR = {vcr: {allow_playback_repeats: true}}

module AuthRequestHelper
  BASE_MAIL = "test@bugmark.net"
  BASE_PASS = "bugmark"

  def create_user(email = BASE_MAIL)
    FB.create(:user, email: email, password: BASE_PASS)
  end

  def basic_creds(email = BASE_MAIL)
    args = [email, BASE_PASS]
    el = ActionController::HttpAuthentication::Basic.encode_credentials(*args)
    {'HTTP_AUTHORIZATION' => el}
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.before(:each) do
    [User, Event, Offer, Issue, Position, Escrow, Contract].each do |klas|
      klas.all.each {|x| x.destroy}
    end
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.include Warden::Test::Helpers

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
end






