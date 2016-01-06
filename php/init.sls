# Detect OS family which determines the location of the PHP config files
{% if grains['os_family'] == 'RedHat' %}
  {% set php_conf_dir = '/etc/php' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set php_conf_dir = '/etc/php5' %}
{% endif %}

php:

# Some systems need an additional package repo to install newer versions of PHP.

# Note: Adding a PPA will malfunction on Linux Mint. Commenting this out for now.
# See https://github.com/saltstack/salt/pull/22971 for details.
# Until then we'll use the default version of PHP5.
# To upgrade PHP manually, run 'sudo add-apt-repository ppa:ondrej/php5-5.6' from the command line,
# then run salt-call again

  {% if grains['os_family'] == 'Debian' and grains['os'] != 'Mint' %}
  pkgrepo.managed:
    - humanname: Ondrej PHP 5.6
    - name: ppa:ondrej/php5-5_6
    - ppa: ondrej/php5-5.6
    - file: /etc/apt/sources.list.d/ondrej-php5-5_6-trusty.list
    - refresh_db: true
  {% endif %}

# TODO: Add IUS or Webtatic on CentOS
# TODO: Add support for PHP 7

# Install PHP itself
  pkg.installed:
    {% if grains['os_family'] == 'Debian' %}
    - fromrepo: ppa:ondrej/php5-5.6
    {% endif %}
    - names:
      {% if grains['os_family'] == 'Debian' %}
      # PHP extensions like devel, pdo, opcache are included in php5 core on Debian
      - php5
      - php5-cli
      - php5-gd
      - php5-memcached
      - php5-mysqlnd
      - php5-xdebug
      {% elif grains['os'] == 'Fedora'%}
      - php
      - php-cli
      - php-devel
      - php-gd
      - php-mbstring
      - php-pecl-memcached
      - php-pecl-xdebug
      - php-mysqlnd
      - php-opcache
      - php-pdo
     {% endif %}

# Manage PHP config files. These vary in location and structure by OS/distro.

{% if grains['os_family'] == 'Debian' %}

# Warning: the PHP config files here have lots of debugging settings turned on like
# xdebug and a 0 second timeout on the opcache. These settings are meant for dev
# machines and are not suitable for a production server.

{{php_conf_dir}}/apache2/php.ini:
  file.managed:
    - source: salt://php/php.ini
    - user: root
    - group: root
    - mode: 644

{{php_conf_dir}}/mods-available/xdebug.ini:
  file.managed:
    - source: salt://php/xdebug.ini
    - user: root
    - group: root
    - mode: 644

php-opcache-enable:
  cmd.run:
    - name: php5enmod opcache

{% endif %}

# Install Composer (from https://docs.saltstack.com/en/latest/ref/states/all/salt.states.composer.html)
get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/
    - require:
      - pkg: php

install-composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get-composer

install-drush:
  cmd.run:
    - name: 'composer global require drush/drush'
    - unless: test -f ~/.composer/vendor/drush/drush/drush
    - require:
      - cmd: install-composer

add-drush-to-path:
  file.append:
    - name: '/home/{{grains['id']}}/.bashrc'
    # TODO: the above line needs to be added to .bash_profile on OSX
    - text: 'export PATH="$HOME/.composer/vendor/bin:$PATH"'
    - unless: which drush


