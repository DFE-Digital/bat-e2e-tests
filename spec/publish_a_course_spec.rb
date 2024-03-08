RSpec.describe "Publish a course", type: :feature do
  scenario "User can publish a new course" do
    visit "#{ENV["PUBLISH_URL"]}/sign-in"
    click_on "Sign in using a Persona"
    click_on "Login as Anne"
    click_on "Add course"

    expect(page).to have_content("What type of course?")

    choose "Primary"
    click_on "Continue"

    choose "Primary with geography and history"
    click_on "Continue"

    choose "5 to 11"
    click_on "Continue"

    choose "PGCE with QTS"
    click_on "Continue"

    choose "Fee - no salary"
    click_on "Continue"

    choose "Full time"
    click_on "Continue"

    check "Avanti Fields School"
    click_on "Continue"

    choose "No"
    click_on "Continue"

    choose "As soon as the course is on Find - recommended"
    click_on "Continue"

    choose "March 2025" # TODO: this will break after March 2025
    click_on "Continue"

    click_on "Add course"

    expect(page).to have_content("Your course has been created")
    within("section[data-qa='courses__table-section']") do
      course = page.all(".govuk-table__row").find do |row|
        row.text.include?("Primary with geography and history") &&
          row.text.include?("Draft") &&
          row.text.include?("No - still in draft")
      end
      _course_name = course.all("td")[0].text.split("\n").first
    end
  end
end
