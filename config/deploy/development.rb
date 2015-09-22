role :app, %w{ubuntu@dev.remoteassistant.me}
role :web, %w{ubuntu@dev.remoteassistant.me}
role :db,  %w{ubuntu@dev.remoteassistant.me}

set :rails_env, "production"
set :stage, 'development'
set :application, 'web'
set :repo_url, 'git@bitbucket.org:remoteassistant/admin.git'

set :branch, ENV["REVISION"] || "development"
set :deploy_to, '/home/ubuntu/admin'

server 'dev.remoteassistant.me', user: 'ubuntu', roles: %w{web app}
