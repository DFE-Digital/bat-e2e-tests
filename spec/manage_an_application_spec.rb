RSpec.describe "Manage an application", type: :feature do
  scenario "User manages a teachers course application" do
    # Sign into apply as support user
    visit "#{ENV.fetch("APPLY_URL")}/support"
    click_on "Sign in using DfE Sign-in"

    fill_in "Email address", with: ENV.fetch("SUPPORT_EMAIL")
    fill_in "Password", with: ENV.fetch("SUPPORT_PASSWORD")
    click_on "Sign in"
    sleep(2) # Sign in takes a while

    # Sign in as Provider
    primary_navigation = page.find(".app-primary-navigation__nav")
    within(primary_navigation) do
      page.find("a", text: "Providers").click
    end

    application_filters = page.find(".app-filter")
    within(application_filters) do
      fill_in "q", with: ENV.fetch("PROVIDER_ID")
      click_on "Apply filters"
    end

    sleep(1) # Wait for filter
    filtered_providers = page.find(".moj-filter-layout__content")
    within(filtered_providers) do
      page.find("a", text: ENV.fetch("PROVIDER_ID")).click
    end

    tab_navigation = page.find(".app-tab-navigation")
    within(tab_navigation) do
      page.find("a", text: "Users").click
    end

    # Grant Provider user all permissions
    user_table = page.find(".govuk-table")
    within(user_table) do
      user_row = page.all(".govuk-table__row")[1]
      within(user_row) do
        # Sign is as first Provider user
        click_on "Update permissions"
      end
    end

    permissions = [
      "Manage users",
      "Manage organisation permissions",
      "Manage interviews",
      "Make decisions",
      "Access safeguarding information",
      "Access diversity information",
    ]
    permissions.each do |permission|
      check permission
    end
    click_on "Save permissions"

    click_on "Sign in as this provider user"
    click_on "Visit Manage"

    # As Provider user on Manage

    if page.has_content?("Data sharing agreement")
      check "agrees to comply with the data sharing practices outlined in this agreement"
      click_on "Continue"

      expect(page).to have_content("Data sharing agreement signed")
      click_on "view applications"
    end

    application_card = page.all(".app-application-card").find do |application|
      application.text.include?(ENV.fetch("COURSE_ID")) &&
        application.text.include?("Received")
    end
    within(application_card) do
      page.find(".govuk-link").click
    end

    unless page.has_content?("Set up interview")
      cancel_interview
    end
    setup_interview

    make_decision

    withdraw_offer
  end

  private

  def setup_interview
    meeting_address = Faker::Address.full_address

    click_on "Set up interview"
    fill_in "Day", with: "01"
    fill_in "Month", with: "01"
    fill_in "Year", with: "2025"
    fill_in "Start time", with: "12:00"
    fill_in "Address or online meeting details", with: meeting_address
    click_on "Continue"

    expect(page).to have_content("Check and send interview details")
    expect(page).to have_content("1 January 2025")
    expect(page).to have_content("12pm (midday")
    expect(page).to have_content(meeting_address)
    click_on "Send interview details"

    expect(page).to have_content("Interview set up")
    email = wait_for_email(to: ENV["CANDIDATE_EMAIL"])
    expect(email.subject).to include("Interview arranged")
  end

  def cancel_interview
    tab_navigation = page.find(".app-tab-navigation")
    within(tab_navigation) do
      page.find("a", text: "Interviews").click
    end

    click_on "Cancel interview"

    expect(page).to have_content("Reason for cancelling interview")

    fill_in "provider-interface-cancel-interview-wizard-cancellation-reason-field",
            with: Faker::Lorem.sentence(word_count: 50)
    click_on "Continue"

    expect(page).to have_content("Check and send interview cancellation")
    click_on "Send cancellation"

    expect(page).to have_content("Interview cancelled")
    email = wait_for_email(to: ENV["CANDIDATE_EMAIL"])
    expect(email.subject).to include("Interview cancelled")
  end

  def make_decision
    click_on "Make decision"

    expect(page).to have_content("Make a decision")
    choose "Make an offer"
    click_on "Continue"

    expect(page).to have_content("Conditions of offer")
    click_on "Continue"

    expect(page).to have_content("Check and send offer")
    click_on "Send offer"

    expect(page).to have_content("Offer sent")
    email = wait_for_email(to: ENV["CANDIDATE_EMAIL"])
    expect(email.subject).to include("Successful application")
  end

  def withdraw_offer
    click_on "Withdraw offer"

    fill_in "Tell us why you are withdrawing the offer",
            with: Faker::Lorem.sentence(word_count: 50)
    click_on "Continue"

    expect(page).to have_content("Check and confirm withdrawal")
    click_on "Withdraw offer"

    expect(page).to have_content("Offer successfully withdrawn")
  end
end
