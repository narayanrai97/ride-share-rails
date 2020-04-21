# Preview all emails at http://localhost:3000/rails/mailers/driver_mailer
class DriverMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/driver_mailer/signup_confirmation
  def signup_confirmation
    DriverMailer.signup_confirmation
  end

end
