python:
  pkg.latest:
    - names:
      - python
      - python-dev
      - python-pip
      - python3
      - python3-pip
      - python3-dev
{% if grains['os_family'] == 'Debian' %}
      # libssl-dev is needed to compile the mysqlclient package
      - libssl-dev
      - libapache2-mod-wsgi-py3
      # libraries needed to install the Pillow package
      - libjpeg8
      - libjpeg62-dev
      - libfreetype6
      - libfreetype6-dev
{% elif grains['os_family'] == 'RedHat' %}
      # openssl-devel is needed to compile the mysqlclient pip module
      - openssl-devel
      - mod_wsgi
      - python3-mod_wsgi
{% endif %}

pip_modules:
  pip.installed:
    - bin_env: /usr/bin/pip3
    - names:
      - Django
      - mysqlclient
      - virtualenv
    - require:
      - pkg: python3-dev
