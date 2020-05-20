require "rails_helper"

RSpec.describe DriverMailer, type: :mailer do
  let!(:organization) { Organization.create(name: "my charity",
    use_tokens: false, street: "123 Pine St", city: "Durham", state: "NC", zip: "27709")}
  let!(:driver) { Driver.create(first_name: "John", last_name: "Doe", email: "john.doe@gmail.com",
    password: "Pa$$word20", organization_id: organization.id)
  }
  describe "signup_confirmation" do
    let(:mail) { DriverMailer.signup_confirmation(driver) }

    it "renders the headers" do
      expect(mail.subject).to eq("Sign up confirmation")
      expect(mail.to).to eq([driver.email])
      expect(mail.from).to eq(["noreply@ctd-crsn.org"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
