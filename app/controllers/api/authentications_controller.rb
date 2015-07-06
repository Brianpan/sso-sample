class Api::AuthenticationsController < ApplicationController
  protect_from_forgery with: :null_session
  def show
    begin
      @user = User.find_by(userAuto: params[:id])
      render json: {code: "ok", user: @user}
    rescue ActiveRecord::RecordNotFound
      render json: {code: "error"}
    end   
  end
    
  def create 
  	# create user , and devise will auto patch with encrypted_password
    # devise 會自動在做加密
    @user = User.new(user_params)
    # 把devise做的加密變回來
    # save the encrypted password from client side
    @user.update_attribute(:encrypted_password, user_params[:password])
    begin 
      if @user.save
        # send confirm mail
        RegistrationsMailer.sendmail({user: @user, subject: "welcome_mail"}).deliver
        # render status 
        render json: {code: "success", user_info: @user}
      else
        render json: {code: "error!"}	
      end
    rescue ActiveRecord::RecordNotUnique
      render json: {code: "error"}  
    end	
  end

  def update
  end
  
  def destroy
  end
  
  def confirmation
    begin
      @user = User.find_by(confirmation_token: params[:confirmation_token])
      @user.update_attribute(:confirmed_at, Time.now)
      render json: {code: "ok"}
    rescue ActiveRecord::RecordNotFound
      render json: {error: "token not found"}
    end 
  end 

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up){|u| u.permit!}
  end

  def user_params
    params.require(:user).permit!
  end	
end