class CustomAuthenticator < CASino::Authenticator

  # @param [Hash] options
  def initialize(options)
    @options = options

    @model = "#{@options[:table].classify}".constantize
  end

  def validate(username, password)
    @model.validate(username, password)
  end

end