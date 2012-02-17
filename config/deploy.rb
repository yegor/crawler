require "bundler/capistrano"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano" 

set :application, "AppStore Crawler"
set :repository,  "git@github.com:yegor/crawler.git"

set :scm, :git

set :rvm_ruby_string, '1.9.2'

role :web, "176.9.99.79"                  
role :app, "176.9.99.79"                  
role :db,  "176.9.99.79", :primary => true
role :db,  "176.9.99.79"

set :deploy_to, "/mnt/apps/crawler/"
set :branch, "master"

set :user, "app"
set :password, "123qwe"
default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :rails_env, "production"

namespace :deploy do
  desc "Link in the database.yml and memcached.yml"
  task :link_configs do
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/sphinx.yml #{release_path}/config/sphinx.yml"
    run "ln -nfs #{deploy_to}/#{shared_dir}/db/sphinx #{release_path}/db/sphinx"
  end
  
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ts:config"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ts:index"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake ts:restart"
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake assets:precompile"
  end
end


after 'deploy:update_code', 'deploy:link_configs'