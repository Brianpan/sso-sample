class Api::UsersController < CASino::ApplicationController
  include CASino::SessionsHelper
  include CASino::AuthenticationProcessor

  def tickets
  	if request.cookies[:tgt]
  	  curr_ticket = CASino::LoginTicket.find_by(ticket: request.cookies[:tgt])
  	else
  	  curr_ticket = CASino::LoginTicket.create
  	  request.cookies[:tgt] = curr_ticket.ticket
  	end	
  	
    render text: curr_ticket.ticket
  end

  def sign_in
    # if current_user
    #   render text: current_user
    # else
    #   render json: "none"
    # end
    if CASino::ServiceTicket.exists?(ticket: params[:stk])
      uid = CASino::ServiceTicket.find_by(ticket: params[:stk]).ticket_granting_ticket.user.username
    end
    render json: uid
  end

  def get_cookies
  	# curr_ticket = CASino::LoginTicket.create
  	tgt = current_ticket_granting_ticket
  	#handle_signed_in(tgt)
  	render json: tgt
  end	
end