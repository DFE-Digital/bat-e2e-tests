require "rspec"
require "capybara/rspec"

Capybara.configure do |capybara|
  capybara.default_driver = if ENV["CI"]
                              :selenium_chrome_headless
                            else
                              :selenium_chrome
                            end
end
