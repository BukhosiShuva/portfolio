# app/mailers/contact_mailer.rb
class ContactMailer < ApplicationMailer
  default from: "bukhosishuva@gmail.com"

  def contact_form_submission(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(to: "bukhosishuva@gmail.com", subject: "New Contact Form Submission")
  end
end
