RSpec.describe "Apply for a course", type: :feature do
  let(:course_url) do
    find_url = ENV.fetch("FIND_URL")
    provider = ENV.fetch("PROVIDER_ID")
    course = ENV.fetch("COURSE_ID")
    "#{find_url}/course/#{provider}/#{course}"
  end

  scenario "User can apply for a course" do
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
end
