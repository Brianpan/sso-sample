class Api::AuthenticationsController < ApplicationController
  # json type will skip csrf auth
  protect_from_forgery with: :null_session, if: Proc.new{|c| c.request.format == 'application/json'}
  skip_before_filter :verify_authenticity_token, if: Proc.new{|c| c.request.format == 'application/json'}
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
    begin
      @user = User.find_by(userAuto: params[:id])
      @user.update!(user_params)
      render json: {code: "ok", user: @user}  
    rescue ActiveRecord::RecordNotFound
      render json: {code: "error"}  
    rescue 
      render json: {code: "error"} 
    end  
  end
  
  def destroy
    @uid = params[:id]
    begin
      @user = User.find_by(userAuto: @uid)
      if @user.destroy
        render json: {code: "ok"}
      else
        render json: {code: "failed"}
      end  
    rescue Exception => e
      render json: {code: e}
    end  
  end

  # --- about password---
  def confirmation
    begin
      @user = User.find_by(confirmation_token: params[:confirmation_token])
      @user.update_attribute(:confirmed_at, Time.now)
      render json: {code: "ok"}
    rescue ActiveRecord::RecordNotFound
      render json: {error: "token not found"}
    end 
  end 
  
  def password_validation
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'

    begin 
      @user = User.find_by(userAuto: params[:id])
      @password = Digest::SHA1.hexdigest params[:password]
      validated = @user.encrypted_password ? @user.encrypted_password : @user.userPassword
  
      if validated == @password
        render json: {code: "ok"}
      else
        render json: {code: "error"}
      end  

    rescue
      render json: {code: "error"}
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