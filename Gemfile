source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3']
gem 'facter', '>= 1.7.0'
gem 'metadata-json-lint', :require => false
gem 'puppet', puppetversion
gem 'puppet-lint', '>= 0.3.2'
gem 'facter', '>= 1.7.0'
gem 'rspec', '< 3.2',      :require => false if RUBY_VERSION =~ /^1\.8/
gem 'rspec-puppet-facts',        :require => false
gem 'metadata-json-lint',  :require => false

group :system_tests do
  gem 'beaker', :require => false
  gem 'beaker-puppet_install_helper', :require => false
  gem 'serverspec',          :require => false
end
