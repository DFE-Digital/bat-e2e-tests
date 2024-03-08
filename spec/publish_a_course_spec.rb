RSpec.describe "Publish a course", type: :feature do
  scenario "User can publish a new course" do
    visit "#{ENV["PUBLISH_URL"]}/sign-in"
    click_on "Sign in using a Persona"
    click_on "Login as Anne"
    click_on "Add course"

    expect(page).to have_content("What type of course?")

    choose "Primary"
    click_on "Continue"
  end
end
