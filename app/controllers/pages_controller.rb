# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def landing
  end

  def home
  end

  def about
  end

  def portfolio
  end

  def portfolioprojectEvo
  end

  def portfolioprojectEmerge
  end

  def portfolioprojectCurl
  end

  def contact
    @contact_form = ContactForm.new
  end

  def send_contact_form
    @contact_form = ContactForm.new(contact_form_params)

    if @contact_form.valid?
      # Send email
      ContactMailer.contact_form_submission(@contact_form.name, @contact_form.email, @contact_form.message).deliver_now
      flash[:notice] = "Thank you for contacting me! I will get back to you shortly."
      redirect_to contact_path
    else
      flash.now[:alert] = "There was a problem with your submission. Please try again."
      render :contact
    end
  end

  private

  def contact_form_params
    params.require(:contact_form).permit(:name, :email, :message)
  end
end
