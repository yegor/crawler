source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'
gem 'hpricot'
#gem 'whenever', :require => false

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem "rspec-rails", ">= 2.6.1", :group => [:development, :test]
gem 'factory_girl', :group => [:development, :test]
gem 'whenever'
gem 'thinking-sphinx'

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :development do
  gem 'mongrel', '>= 1.2.0.pre2'
  gem 'annotate', :git => 'git://github.com/jeremyolliver/annotate_models.git', :branch => 'rake_compatibility'
end