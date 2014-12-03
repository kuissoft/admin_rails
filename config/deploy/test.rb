role :app, %w{ubuntu@test.remoteassistant.me}
role :web, %w{ubuntu@test.remoteassistant.me}
role :db,  %w{ubuntu@test.remoteassistant.me}

set :rails_env, "production"
set :stage, 'test'
set :application, 'web'
set :repo_url, 'git@bitbucket.org:remoteassistant/admin.git'

set :branch, "development"
set :deploy_to, '/home/ubuntu/admin'

server 'test.remoteassistant.me', user: 'ubuntu', roles: %w{web app}
