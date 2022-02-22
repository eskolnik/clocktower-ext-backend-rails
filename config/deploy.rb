# config valid for current version and patch releases of Capistrano
lock "~> 3.16.0"

set :application, "paperweight_clocktower"
set :repo_url, "git@github.com:eskolnik/clocktower-ext-backend-rails.git"

set :branch, "deploy"

set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_files, "config/master.key"
# append :linked_files, "config/master.key"

admin_group_name, "clocktower_admin"
# set :mod_group_directories, ["current"]

namespace :deploy do
  task :mod_group do
    on roles :app do
      execute "chgrp -R #{admin_group_name} #{release_path} && chmod -R g+w #{release_path}"
      info "Group of #{release_path} changed to #{admin_group_name} and writable bit set"
    end
  end

  task :passenger_stop do
    on roles :app do
      begin
        # execute "cd #{current_path} && passenger stop"
        execute "cd #{current_path} && kill $(passenger status | awk -F'Standalone is running on PID |,' '{print $2}')"
        info "Passenger stopped in #{current_path}"
      rescue
        info "Passenger was not running"
      end
    end
  end

  task :passenger_start do
    on roles :app do
      execute "cd #{current_path} && passenger start"
      info "Passenger restarted in #{current_path}"
    end
  end

  task :published do
    invoke "deploy:mod_group"
  end

  task :started do
    invoke "deploy:passenger_stop"
  end
  
  task :finished do
    invoke "deploy:passenger_start"
  end
  
  # attempt to reboot server if reploy fails
  after :failed, :passenger_start

  namespace :check do
    before :linked_files, :set_master_key do
      on roles(:app), in: :sequence, wait: 10 do
        master_key_remote_path = "#{shared_path}/config/master.key"
        production_key_remote_path = "#{shared_path}/config/production.key"

        unless test("[ -f #{master_key_remote_path} ]")
          upload! "config/master.key", "#{master_key_remote_path}"
          execute "chgrp #{fetch(:mod_group)} #{master_key_remote_path} && chmod g+r #{master_key_remote_path}"
        end  

        unless test("[ -f #{production_key_remote_path} ]")
          upload! "config/production.key", "#{production_key_remote_path}"
          execute "chgrp #{fetch(:mod_group)} #{production_key_remote_path} && chmod g+r #{production_key_remote_path}"
        end
      end
    end

    # before :linked_files, :set_dhparamfile do
    #   on roles(:app), in: :sequence, wait: 10 do
    #     dhparam_remote_path = "#{shared_path}/config/dhparam.pem"
    #     unless test("[ -f #{dhparam_remote_path} ]")
    #       upload! "config/dhparam.pem", "#{dhparam_remote_path}"
    #       execute "chgrp #{fetch(:mod_group)} #{dhparam_remote_path} && chmod g+r #{dhparam_remote_path}"
    #     end
    #   end
    # end
    
  end
end

# ASDF installed in opt for global access
set :asdf_custom_path, "/opt/.asdf"  # only needed if not '~/.asdf'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
set :default_env, { path: "/opt/.asdf/shims:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
