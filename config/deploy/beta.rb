set :user, "brian"
set :deploy_to, "/home/#{fetch(:user)}/projects/#{fetch(:application)}"
set :rvm_ruby_version, '2.1.5'
 
server '104.200.18.210',
  roles: %w{web app db},
  user: fetch(:user),
  ssh_options: {
    user: 'brian', # overrides user setting above
    keys: %w(/Users/brianpan/.ssh/id_rsa),
    forward_agent: false,
    auth_methods: %w(publickey password)
    # password: 'please use keys'
  }