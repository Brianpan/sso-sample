class User < ActiveRecord::Base
    establish_connection(:adapter  => "mysql2",
    :host     => "localhost",
    :username => "root",
    :password => "aniarcqweqwe",
    :database => "articles")
    self.table_name = "kwuser"

    def self.validate(username, password)
	    begin 
        user = find_by_email!(username)
        if user.valid_password?(password) && user.active_for_authentication?
  	      { username: user.email }
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
    else
      # puts self.password	
      return (encrypt_pass == userPassword) 
    end
  end	
end
