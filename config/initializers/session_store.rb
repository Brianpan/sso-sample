# Be sure to restart your server when you modify this file.

# Rails.application.config.session_store :cookie_store, key: '_sso-carebest_session'
Rails.application.config.session_store :redis_session_store, {
	key: "_sso-carebest_session",
	redis: {
	  expire_after: 120.minutes
	}
	# serializer: :php
}