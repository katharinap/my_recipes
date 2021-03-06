ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require 'minitest/rails/capybara'
require 'minitest/autorun'
require 'shoulda/context'
require 'minitest/reporters'
require 'mocha/mini_test'
require 'capybara/rails'
require_relative 'browser/lib/dom_helper'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
DatabaseCleaner.strategy = :transaction
class Minitest::Spec
  before :each do
    DatabaseCleaner.start
  end

  after :each do
    DatabaseCleaner.clean
  end
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

Capybara.ignore_hidden_elements = false
Capybara.javascript_driver = :webkit

class ActiveRecord::Base
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end

# Forces all threads to share the same connection. This works on
# Capybara because it starts the web server in a thread.
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include BrowserTests::DomHelper

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
