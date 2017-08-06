# config valid only for current version of Capistrano
lock "3.9.0"

set :application, "qna"
set :repo_url, "git@github.com:darialapina/thinknetica.git"

set :deploy_to, "/home/deployer/qna"
set :deploy_user, 'deployer'

set :rbenv_type, :user
set :rbenv_ruby, '2.4.1'

set :sidekiq_options, "-q default -q mailers"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", ".env"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
