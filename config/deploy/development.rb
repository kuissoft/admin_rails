role :app, %w{ubuntu@dev.remoteassistant.me}
role :web, %w{ubuntu@dev.remoteassistant.me}
role :db,  %w{ubuntu@dev.remoteassistant.me}

set :stage, 'development'
set :application, 'web'
set :repo_url, 'git@bitbucket.org:remoteassistant/rails.git'

set :branch, "development"
set :deploy_to, '/home/ubuntu/rails'

server 'dev.remoteassistant.me', user: 'ubuntu', roles: %w{web app}