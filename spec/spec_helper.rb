require "rspec"
require "capybara/rspec"
require "dotenv/load"
require "faker"
require "pry"

Capybara.configure do |capybara|
  capybara.default_driver = if ENV["CI"]
                              :selenium_chrome_headless
                            else
                              :selenium_chrome
                            end

  # Allow Capybara to click a <label> even if its corresponding <input> isn't visible on screen.
  # This needs to be enabled when using custom-styled checkboxes and radios, such as those
  # in the GOV.UK Design System.
  capybara.automatic_label_click = true
end
