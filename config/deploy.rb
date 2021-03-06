# config valid only for current version of Capistrano
lock '3.4.0'
# set :rvm_type, :user                     # Defaults to: :auto
set :rvm_ruby_version, '2.2.2'      # Defaults to: 'default'
set :application, 'sso'
set :repo_url, 'git@github.com:Brianpan/sso-sample.git'

set :user, "apps"
set :rails_env, "production"
set :stages, %w(staging live beta)
set :default_stage, "staging"

set :conditionally_migrate, false          # Defaults to false. If true, it's skip migration if files in db/migrate not modified
set :assets_roles, [:web, :app]            # Defaults to [:web]
# set :assets_prefix, 'sso'   # Defaults to 'assets' this should match config.assets.prefix in your rails config/application.rb
# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/application.yml', 'config/cas.yml', 'config/email.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :restart, :restart_passenger do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
      within release_path do
        execute :touch, 'tmp/restart.txt'
      end
     
    end
  end
  after :finishing, 'deploy:restart_passenger'
  
  desc 'Warm up the application by pinging it, so enduser wont have to wait'
  task :ping do
    on roles(:app), in: :sequence, wait: 5 do
      execute "curl -s -D - #{fetch(:ping_url, 'http://www.carebest.com.tw')} -o /dev/null"
    end
  end
 
  after :restart_passenger, :ping
end

namespace :capture do 
  task :capture_simple do 
    on roles(:web) do 
      within "/home/brian/" do 
        capture_txt = capture('cat pass')
        puts capture_txt
      end
    end
  end
end
