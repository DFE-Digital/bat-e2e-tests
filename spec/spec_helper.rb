require "rspec"
require "capybara/rspec"

Capybara.configure do |capybara|
  capybara.default_driver = :selenium_chrome_headless
end
