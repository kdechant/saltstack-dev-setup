# Detect OS family which determines the location of the PHP config files
{% if grains['os_family'] == 'RedHat' %}
  {% set php_conf_dir = '/etc/php' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set php_conf_dir = '/etc/php/7.0' %}
{% endif %}

php:

# Some systems need an additional package repo to install newer versions of PHP.

  {% if grains['os_family'] == 'Debian' %}
    {% if grains['oscodename'] == 'xenial' or grains['oscodename'] == 'sarah' %}
  # Ubuntu 16.04 or Mint 18
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/ondrej/php/ubuntu xenial main
    - dist: xenial
    - require_in:
      pkg: php7.0
    {% else %}
  # Mint 17
  pkgrepo.managed:
    - name: deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main
    - dist: trusty
    - require_in:
      pkg: php5
    {% endif %}
  {% endif %}

# TODO: Add IUS or Webtatic on CentOS

# Install PHP itself
  pkg.installed:
    - names:
      {% if grains['os_family'] == 'Debian' %}
      # PHP extensions like devel, pdo, opcache are included in php5 core on Debian
      - php7.0
      - php7.0-common
      - php7.0-cli
      - php7.0-curl
      - php7.0-gd
      - php7.0-memcached
      - php7.0-mysqlnd
      - php7.0-xdebug
      - libapache2-mod-php7.0
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
      - memcached

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
    - name: phpenmod opcache

enable-php-apache-modules:
  cmd.run:
    - name: 'a2enmod php7.0'
    - require:
      - pkg: php

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


