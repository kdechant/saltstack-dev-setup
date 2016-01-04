mariadb:
  pkg.latest: 
    - names:
      - mariadb
      - mariadb-server
  service.running:
    - names:
      - mariadb
    - watch:
      - pkg: mariadb
      - pkg: mariadb-server
#      - file: /etc/my.cnf
#      - user: apache

