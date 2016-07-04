# Install Ruby

ruby:
  pkg.latest:
    - names:
{% if grains['os_family'] == 'Debian' %}
      - ruby
      - ruby-dev
{% elif grains['os_family'] == 'RedHat' %}
      - ruby
      - rubygems
      - libopenssl-ruby
{% endif %}

# Older Ubuntu/Mint mangle the Ruby installer and make the default 1.9.3.
# Need to fix some symlinks before the gems will install.
{% if grains['oscodename'] == 'trusty' or grains['oscodename'] == 'rosa' %}
/usr/bin/ruby:
  file.symlink:
    - target: '/usr/bin/ruby2.0'
/usr/bin/gem:
  file.symlink:
    - target: '/usr/bin/gem2.0'
{% endif %}

# Install Capistrano and Bundler gems

net-ssh:
  gem.installed:
    - require:
      - pkg: ruby

capistrano:
  gem.installed:
    - version: '=2.15.6'
    - require:
      - pkg: ruby
      - gem: net-ssh

capistrano-ext:
  gem.installed:
    - require:
      - pkg: ruby
      - gem: capistrano

capistrano-deploy-strategy-archive:
  gem.installed:
    - require:
      - pkg: ruby
      - gem: capistrano

capistrano-deploy-scm-passthrough:
  gem.installed:
    - require:
      - pkg: ruby
      - gem: capistrano

bundler:
  gem.installed:
    - require:
      - pkg: ruby
