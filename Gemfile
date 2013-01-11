source :rubygems

# Uncomment the database that you have configured in config/database.yml
# ----------------------------------------------------------------------
# gem 'mysql2', '0.3.10'
# gem 'sqlite3'
gem 'pg', '~> 0.13.2'

# Allows easy switching between locally developed gems, and gems installed from rubygems.org
# See README for more info at: https://github.com/ndbroadbent/bundler_local_development
gem 'bundler_local_development', :group => :development, :require => false
begin
  require 'bundler_local_development'
  Bundler.development_gems = [/^ffcrm_/, /ransack/]
rescue LoadError
end

# Removes a gem dependency
def remove(name)
  @dependencies.reject! {|d| d.name == name }
end

# Replaces an existing gem dependency (e.g. from gemspec) with an alternate source.
def gem(name, *args)
  remove(name)
  super
end

# Bundler no longer treats runtime dependencies as base dependencies.
# The following code restores this behaviour.
# (See https://github.com/carlhuda/bundler/issues/1041)
spec = Bundler.load_gemspec(Dir["./{,*}.gemspec"].first)
spec.runtime_dependencies.each do |dep|
  gem dep.name, *(dep.requirement.as_list)
end

# Remove premailer auto-require
gem 'premailer', :require => false

# Remove fat_free_crm dependency, to stop it from being auto-required too early.
remove 'fat_free_crm'

group :development do
  gem 'thin'
  gem 'quiet_assets'
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git', ref: 'bef0c494956e516540b7a9e72fa03be6576031dd'
  # Mailcatcher is a tool to allow to intercept and view HTML email in development
  gem 'mailcatcher', require: false  

  gem 'guard-rspec', require: false

  # Gems for security and best practices
  gem 'brakeman', require: false
  gem 'rails_best_practices', require: false
  # Uncomment the following two gems to deploy via Capistrano
  gem 'capistrano', '~> 2.13'
  gem 'capistrano-ext', '~> 1.2.1'
  # If deploying to Capistrano and requiring RVM
  gem 'rvm-capistrano', '~> 1.2.7', :require => false
end

group :development, :test do
  gem 'rspec-rails', '~> 2.9.0'
  gem 'headless'
  unless ENV["CI"]
    gem 'debugger', :platform => :mri_19
  end
  gem 'pry-rails'
end

group :test do
  gem 'capybara', '~> 1.1' # v2 and up is not r1.8 compatible.
  gem 'database_cleaner'
  gem "acts_as_fu", "~> 0.0.8"
  gem 'factory_girl_rails', '~> 3.0.0'
end

gem 'unicorn'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier',     '>= 1.0.3'
  # gem 'turbo-sprockets-rails3'
  # gem 'execjs'
  # unless ENV["CI"]
  #   gem 'therubyracer', :platform => :ruby
  # end
end

