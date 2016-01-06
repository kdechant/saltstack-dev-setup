# Detect OS family which determines the location of the PHP config files
{% if grains['os_family'] == 'RedHat' %}
  {% set php_conf_dir = '/etc/php' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set php_conf_dir = '/etc/php5' %}
{% endif %}

php:

# Some systems need an additional package repo to install newer versions of PHP.

# Note: Adding a ppa on apt-based system is not working yet. Needs further investigation.
# Until then we'll use the default version of PHP5.
# To upgrade PHP manually, run 'sudo add-apt-repository ppa:ondrej/php5-5.6' from the command line,
# then run salt-call again

# TODO: Add support for PHP 7
#  {% if grains['os_family'] == 'Debian' %}
#  pkgrepo.managed:
#    - ppa: ondrej/php5-5.6
#  {% endif %}

# Install PHP itself
  pkg.latest:
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

