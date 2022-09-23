# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'faraday'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.8', '>= 5.2.8.1'

group :development, :test do
  gem 'figaro'
  gem 'pry'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
