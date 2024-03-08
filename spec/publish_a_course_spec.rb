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

    course_name = ""
    expect(page).to have_content("Your course has been created")
    within("section[data-qa='courses__table-section']") do
      course = page.all(".govuk-table__row").find do |row|
        row.text.include?("Primary with geography and history") &&
          row.text.include?("Draft") &&
          row.text.include?("No - still in draft")
      end
      course_name = course.all("td")[0].text.split("\n").first
      click_on course_name
    end

    expect(page.find(".govuk-heading-l ")).to have_content(course_name)

    # Fill in course information

    # About this course

    # Course information
    within("div[data-qa='enrichment__about_course']") do
      click_on "Change"
    end
    expect(page.find(".govuk-heading-l ")).to have_content("Course information")
    fill_in "About this course", with: Faker::Lorem.sentence(word_count: 300)
    fill_in "Interview process (optional)", with: Faker::Lorem.sentence(word_count: 200)
    fill_in "School placements", with: Faker::Lorem.sentence(word_count: 300)
    click_on "Update course information"

    # Course length and fees
    within("div[data-qa='enrichment__course_length']") do
      click_on "Change"
    end
    expect(page.find(".govuk-heading-l ")).to have_content("Course length and fees")
    choose "1 year"
    fill_in "Fee for UK students", with: "250"
    fill_in "Fee for international students (optional)", with: "500"
    fill_in "Fee details (optional)", with: Faker::Lorem.sentence(word_count: 200)
    fill_in "Financial support you offer (optional)", with: Faker::Lorem.sentence(word_count: 200)
    click_on "Update course length and fees"

    # Requirements and eligibility
    within("div[data-qa='enrichment__degree_grade']") do
      click_on "Enter degree requirements"
    end
    choose "No"
    click_on "Save"

    within("div[data-qa='enrichment__accept_pending_gcse']") do
      click_on "Enter GCSE and equivalency test requirements"
    end

    page.all("fieldset").each do |fieldset|
      within(fieldset) do
        choose "No"
      end
    end
    click_on "Update GCSEs and equivalency tests"

    click_on "Publish course"
  end
end
