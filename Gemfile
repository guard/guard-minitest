source 'http://rubygems.org'

gemspec

gem 'rake'

require 'rbconfig'
if RbConfig::CONFIG['target_os'] =~ /darwin/i
  gem 'ruby_gntp',  '~> 0.3.4', :require => false
elsif RbConfig::CONFIG['target_os'] =~ /linux/i
  gem 'libnotify',  '~> 0.7.1', :require => false
elsif RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i
  gem 'win32console', :require => false
  gem 'rb-notifu', '>= 0.0.4', :require => false
end

