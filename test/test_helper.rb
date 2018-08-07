ENV["RAILS_ENV"] = "test"
DEVISE_ORM = (ENV["DEVISE_ORM"] || :active_record).to_sym

$LOAD_PATH.unshift File.dirname(__FILE__)
puts "\n==> Devise.orm = #{DEVISE_ORM.inspect}"
require "rails_app/config/environment"
include Devise::TestHelpers
require "orm/#{DEVISE_ORM}"
require 'rails/test_help'
require 'capybara/rails'
require 'timecop'

ActiveSupport::Deprecation.silenced = true

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
class ActionController::TestCase
  include Devise::TestHelpers
end
