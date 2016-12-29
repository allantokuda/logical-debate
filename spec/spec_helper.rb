require File.expand_path("../../config/environment", __FILE__)
require 'capybara/rails' 
require 'factory_girl_rails'
require 'faker'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers
end
