require "rails_helper"

describe "/users/sign_up" do
  it "sign-up form has username field", points: 1, hint: h("label_for_input") do
    visit "/users/sign_up"

    expect(page).to have_selector("label", text: "Username")
  end
end

describe "/users/sign_up" do
  it "sign-up form username field works", points: 2, hint: h("label_for_input") do
    sample_email = "alice@example.com"
    sample_password = "alicepassword"
    sample_username = "alice"

    visit "/users/sign_up"
    fill_in("Email", :with => sample_email)
    fill_in("Password", :with => sample_password)
    fill_in("Password confirmation", :with => sample_password)
    fill_in("Username", :with => sample_username)
    click_on("Create User")

    within("nav") do
      expect(page).to have_content(sample_username)
    end
  end
end

describe "/users/edit" do
  it "edit form has username field", points: 1, hint: h("label_for_input") do
    user = create(:user)
    login_as(user, :scope => :user)

    visit "/users/edit"

    expect(page).to have_selector("label", text: "Username")
  end
end

describe "/users/edit" do
  it "edit form username field works", points: 2, hint: h("label_for_input") do
    user = create(:user)
    login_as(user, :scope => :user)
    new_username = "User-#{Time.now.to_f}"

    visit "/users/edit"
    fill_in("Username", :with => new_username)
    fill_in("Current password", :with => user.password)
    click_on("Update")

    within("nav") do
      expect(page).to have_content(new_username)
    end
  end
end
