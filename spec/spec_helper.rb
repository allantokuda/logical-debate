ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'capybara/rails' 
require 'factory_girl_rails'
require 'faker'

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Rails.application.routes.url_helpers

  # Login
  config.include Warden::Test::Helpers

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end

headers = {}
Rack::Utils.set_cookie_header!(headers, 'agreement', I18n.t('agreement.button'))
cookie_string = headers['Set-Cookie']
Capybara.current_session.driver.browser.set_cookie(cookie_string)
