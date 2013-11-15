source 'https://rubygems.org'

gemspec

gem 'rake'

group :development do
  gem 'ruby_gntp', require: false

  # Used for release
  gem 'gems', require: false
  gem 'netrc', require: false
  gem 'octokit', require: false
end

# The test group will be
# installed on Travis CI
#
group :test do
  gem 'mocha'
  gem 'coveralls', require: false
end
