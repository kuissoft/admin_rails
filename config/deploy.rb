#lock '3.1.0'

set :stages, %w(production development)
set :default_stage, 'development'
set :scm, :git
set :format, :pretty
#set :log_level, :debug

#set :pty, true
set :default_env, { rvm_bin_path: '~/.rvm/bin' }
set :keep_releases, 3

# set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{public/images public/asset log}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  task :uptime do
    on roles(:web), in: :groups do
      uptime = capture(:uptime)
      #puts "#{host.hostname} reports: #{uptime}"
    end
  end
  
  after :publishing, :restart
  after :restart, :uptime

end
