# Detect OS family which determines the name of the Apache package
{% if grains['os_family'] == 'RedHat' %}
  {% set apache_package = 'httpd' %}
{% elif grains['os'] == 'Ubuntu' %}
  {% set apache_package = 'apache2' %}
{% endif %}

httpd:
  pkg.latest:
    - name: {{ apache_package }}
  service.running:
    - watch:
      - pkg: {{ apache_package }}
      - file: /etc/httpd/conf/httpd.conf

/etc/httpd/conf/httpd.conf:
  file.managed:
    - source: salt://apache/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
