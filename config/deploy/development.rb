role :app, %w{ubuntu@54.200.44.207}
role :web, %w{ubuntu@54.200.44.207}
role :db,  %w{ubuntu@54.200.44.207}

set :stage, 'development'
set :application, 'web'
set :repo_url, 'git@bitbucket.org:remoteassistant/rails.git'

set :branch, "development"
set :deploy_to, '/home/ubuntu/rails-development'

server '54.200.44.207', user: 'ubuntu', roles: %w{web app}