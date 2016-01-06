# Detect OS family which determines the name of the Apache package
{% if grains['os_family'] == 'RedHat' %}
  {% set apache_package = 'httpd' %}
  {% set apache_conf = '/etc/httpd/conf/httpd.conf' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set apache_package = 'apache2' %}
  {% set apache_conf = '/etc/apache2/conf/apache2.conf' %}
{% endif %}

{{ apache_package }}:
  pkg.latest:
    - name: {{ apache_package }}
  service.running:
    - watch:
      - pkg: {{ apache_package }}
      - file: {{ apache_conf }}
      - file: /etc/php5/apache2/php.ini  # currently only works on Debian-based systems; will error on RedHat

{{ apache_conf }}:
  file.managed:
    - source: salt://apache/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

