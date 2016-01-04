php:
  pkg.latest:
    - names:
      {% if grains['os'] == 'Fedora'%}
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
