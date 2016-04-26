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

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionController::TestCase
  include Devise::TestHelpers
end

Capybara.javascript_driver = :webkit

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