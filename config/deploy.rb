# frozen_string_literal: true

require 'mina/git'
require 'mina/rails'
require 'mina/bundler'
require 'mina/puma'
require 'mina/rbenv'  # important for Ruby setup
# require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
# require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'vietus'
set :domain, '192.168.100.13'
set :deploy_to, '/home/deploy/vietus'
set :repository, 'https://github.com/saem-mac2op/vietus.git'
set :branch, 'main'
set :user, 'deploy'

set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp/pids', 'tmp/sockets')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/master.key')

task :remote_environment do
  invoke :'rbenv:load'
end

# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')
task :setup do
  command %{mkdir -p "#{fetch(:shared_path)}/config"}
  #command %{touch "#{fetch(:shared_path)}/config/database.yml"}
  command %{touch "#{fetch(:shared_path)}/config/master.key"}
  comment "⚠️  Edit shared/config/database.yml and master.key before deploying."
end

desc "Deploy the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'puma:restart'
  end

  on :launch do
    in_path(fetch(:current_path)) do
      command %(mkdir -p tmp/)
      command %(touch tmp/restart.txt)
    end
  end
end



# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
