class RegistrationsMailer < ApplicationMailer
	def sendmail(mailsettings)
   

	    @user = mailsettings[:user]
	    # @reservation_decorator =  ReservationDecorator.new(@booking)
	    @mailbox = @user.email
	  	mail(to: @mailbox, subject: mailsettings[:subject]) do |format|
	  	  case mailsettings[:subject]
	      when "welcome_mail"
	      	@user.update_attribute(:confirmation_sent_at, Time.now)
	        format.html { render 'welcome_mail', layout: "registrations_mailer" }
	      end
	    end 
    end 
end
