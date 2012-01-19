require "bundler/capistrano"
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
  end
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :whenever do
  desc "Update the crontab file"
  task :update_crontab, :only => { :primary => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec whenever --set environment=#{rails_env} --update-crontab #{application}"
  end
  desc "Clear application's crontab entries using Whenever"
  task :clear_crontab, :only => { :primary => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec whenever --set environment=#{rails_env} --clear-crontab #{application}"
  end
end

after 'deploy:update_code', 'deploy:link_configs'
after "deploy:symlink",     'whenever:update_crontab'