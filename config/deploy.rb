set :application, 'ladder_manager'
set :repo_url, 'git@github.com:mmehlhope/Ladder-Manager.git'
set :user, 'ladder_manager'
set :deploy_to, "/home/ladder_manager/ladder_manager_app" # Set deploy_to to /home/USERNAME/APPLICATION
set :user_sudo, false
set :rails_env, "production" # sets your server environment to Production mode
set :scm, :git
set :pty, true

role :web, "162.243.208.189" # Your HTTP server, Apache/etc
role :app, "162.243.208.189"
role :db, "162.243.208.189", :primary => true



# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }


# set :format, :pretty
# set :log_level, :debug

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
