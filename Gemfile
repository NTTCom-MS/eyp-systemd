source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3']
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 0.3.2'
gem 'facter', '>= 1.7.0'

group :system_tests do
  gem 'beaker', '~>3.13',     :require => false
  gem 'beaker-rspec', '> 5',  :require => false
  gem 'beaker_spec_helper',   :require => false
  gem 'serverspec',           :require => false
  gem 'rspec', '< 3.2',       :require => false if RUBY_VERSION =~ /^1\.8/
  gem 'rspec-puppet',         :require => false
  gem 'metadata-json-lint',   :require => false
end
