RSpec.describe "Apply for a course", type: :feature do
  let(:course_url) do
    find_url = ENV.fetch("FIND_URL")
    provider = ENV.fetch("PROVIDER_ID")
    course = ENV.fetch("COURSE_ID")
    "#{find_url}/course/#{provider}/#{course}"
  end

  scenario "User can apply for a course" do
    find_course_to_apply_for

    if page.has_content?("You have already added an application")
      withdraw_application
      click_on "Sign out"
      find_course_to_apply_for
    end
    apply_for_course
  end

  private

  def find_course_to_apply_for
    visit course_url
    click_on "Apply for this course"

    expect(current_url).to start_with "#{ENV["APPLY_URL"]}/"
    expect(page).to have_content("Do you already have an account?")
    choose "Yes, sign in"
    fill_in "Email address", with: ENV["CANDIDATE_EMAIL"]
    click_on "Continue"

    email = wait_for_email(to: ENV["CANDIDATE_EMAIL"])

    visit sign_in_link(email)
    click_on "Sign in"
  end

  def apply_for_course
    # Selecting a course
    expect(page.find(".govuk-heading-xl")).to have_content("You selected a course")
    expect(page).to have_content(ENV.fetch("COURSE_ID"))
    expect(page).to have_content("Do you want to apply to this course?")

    choose "Yes"
    click_on "Continue"

    # View application
    expect(page.find(".govuk-heading-l")).to have_content("Your application to")
    expect(page).to have_content(ENV.fetch("COURSE_ID"))
    click_on "Review application"

    # Review application
    expect(page.find(".govuk-heading-l")).to have_content("Review your application")
    expect(page).to have_content(ENV.fetch("COURSE_ID"))
    click_on "Confirm and submit application"

    expect(page).to have_content("Application submitted")
  end

  def withdraw_application
    course_application = page.all(".app-application-item").find do |app|
      app.text.include?(ENV.fetch("COURSE_ID")) &&
        app.text.include?("Awaiting decision")
    end
    within(course_application) do
      page.find(".govuk-link").click
    end

    expect(page.find(".govuk-heading-l")).to have_content("Your application to")
    click_on "withdraw this application"

    expect(page.find(".govuk-heading-xl")).to have_content(
      "Are you sure you want to withdraw this application?",
    )
    expect(page).to have_content(ENV.fetch("COURSE_ID"))
    click_on "Yes I’m sure – withdraw this application"

    check "I’m going to apply (or have applied) to a different training provider"
    click_on "Continue"
  end
end
