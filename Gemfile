source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby_version_file = File.expand_path('.ruby-version', __dir__)
ruby_version_exact = File.read(ruby_version_file).strip
ruby ruby_version_exact

gem 'faraday'
gem 'marcel'

group :development do
  gem 'rubocop'
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rspec', '~> 3.10'
  gem 'simplecov', '~> 0.21', require: false
  gem 'simplecov-rcov', '~> 0.2', require: false
  gem 'webmock', require: false
end