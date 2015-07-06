email_setting = YAML::load(File.open(File.join(Rails.root, "config", "email.yml")))
ActionMailer::Base.smtp_settings = email_setting[Rails.env]
ActionMailer::Base.default_url_options[:host] = "http://localhost:3000"