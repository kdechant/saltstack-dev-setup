# Detect OS family which determines the name of the Apache package
{% if grains['os_family'] == 'RedHat' %}
  {% set mariadb_package = 'mariadb' %}
  {% set mariadb_service = 'mariadb' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set mariadb_package = 'mariadb-client' %}
  {% set mariadb_service = 'mysql' %}
{% endif %}

mariadb:
  pkg.latest:
    - names:
      - {{ mariadb_package }}
      - mariadb-server
      - libmariadbclient-dev
  service.running:
    - names:
      - {{ mariadb_service }}
    - watch:
      - pkg: {{ mariadb_package }}
      - pkg: mariadb-server
      - file: /etc/mysql/my.cnf
#      - user: apache

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/my.cnf
    - user: root
    - group: root
    - mode: 644


