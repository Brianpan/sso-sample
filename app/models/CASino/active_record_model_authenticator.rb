require 'casino/authenticator'
class CASino::ActiveRecordModelAuthenticator < CASino::Authenticator

  # @param [Hash] options
  def initialize(options)
    @options = options

    @model = "User".constantize
  end

  def validate(username, password)
    @model.validate(username, password)
  end

end