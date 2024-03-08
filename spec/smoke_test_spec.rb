RSpec.describe "Smoke Test", type: :feature do
  scenario "Visit Wikipedia homepage" do
    visit "https://www.wikipedia.org/"
    expect(page).to have_title("Wikipedia")
  end
end
