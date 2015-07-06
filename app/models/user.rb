class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
    establish_connection(:adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "aniarcqweqwe",
    :database => "articles")
    self.table_name = "kwuser"

  before_save :create_default_data
  
  def create_default_data
    self.userFullname = "Brian Pan"
    self.userConfirmCode = Digest::SHA1.hexdigest userFullname
    self.userFbUID = nil
  end   

  #----- Devise ------#
  # devise not sent mail overwrite confirmable in gem
  def send_on_create_confirmation_instructions
    # send_devise_notification(:confirmation_instructions)
  end


  #----- sso -----#
  # authenticator 導過來的validator

  def self.validate(username, password)
    begin 
      user = find_by_email!(username)
      # if user.valid_password?(password) && user.active_for_authentication?
	    if user.valid_password?(password)
        token = user.generate_access_token
        ##pass optional variables in extra_attributes
        { username: user.email, extra_attributes:{authtoken: token}}
	    else
	      false
	    end

    rescue 
      false
    end 
  end
  

  def active_for_authentication?
    # !inactive && confirmed?
    confirmed?
  end

  def confirmed?
    !!confirmed_at
  end

	def valid_password?(password)
  	encrypt_pass = Digest::SHA1.hexdigest password
    if encrypted_password != nil
      return (encrypt_pass == encrypted_password)
      # return true
    else
      # puts self.password	
      return (encrypt_pass == userPassword) 
    end
  end	
  
  ## authtoken
  def generate_access_token
    begin
      token = SecureRandom.hex
    end while User.exists?(authtoken: token)
    self.authtoken = token
    self.save
    token
  end  
end
