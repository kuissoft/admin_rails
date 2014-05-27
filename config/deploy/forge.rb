role :app, %w{web@sedrick.cz}
role :web, %w{web@sedrick.cz}
role :db,  %w{web@sedrick.cz}

set :rails_env, "production"
set :stage, 'forge'
set :application, 'web'
set :repo_url, 'git@bitbucket.org:remoteassistant/admin.git'

set :branch, "forge"
set :deploy_to, '/home/web/ruby/admin'

server 'sedrick.cz', user: 'web', roles: %w{web app}
