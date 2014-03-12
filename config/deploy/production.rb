role :app, %w{ubuntu@pro.remoteassistant.me}
role :web, %w{ubuntu@pro.remoteassistant.me}
role :db,  %w{ubuntu@pro.remoteassistant.me}

set :rails_env, "production"
set :stage, 'production'
set :application, 'web'
set :repo_url, 'git@bitbucket.org:remoteassistant/rails.git'

set :branch, "production"
set :deploy_to, '/home/ubuntu/rails'

server 'pro.remoteassistant.me', user: 'ubuntu', roles: %w{web app}
