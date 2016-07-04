# Detect OS family which determines the name of the Apache package
{% if grains['os_family'] == 'RedHat' %}
  {% set apache_package = 'httpd' %}
  {% set apache_conf_dir = '/etc/httpd' %}
  {% set apache_conf = '/etc/httpd/conf/httpd.conf' %}
{% elif grains['os_family'] == 'Debian' %}
  {% set apache_package = 'apache2' %}
  {% set apache_conf_dir = '/etc/apache2' %}
  {% set apache_conf = '/etc/apache2/apache2.conf' %}
  {% set websites_root = '/home/' ~ grains['id'] ~ '/sites' %}
{% endif %}

# Debian/Ubuntu/Mint specific Apache setup
{% if grains['os_family'] == 'Debian' %}

# Main apache config file - apache2.conf
{{ apache_conf }}:
  file.managed:
    - source: salt://apache/ubuntu/apache2.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

{{ apache_conf_dir }}/envvars:
  file.managed:
    - source: salt://apache/ubuntu/envvars
    - user: root
    - group: root
    - mode: 644
    - template: jinja

# Wildcard virtual hosts. Currently only supported on Debian. Would be easy to implement on OSX.
{{ apache_conf_dir }}/sites-available/vhosts-wildcard.conf:
  file.managed:
    - source: salt://apache/ubuntu/vhosts-wildcard.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        apache_conf_dir: {{apache_conf_dir}}
        websites_root: {{websites_root}}

{{ apache_conf_dir }}/sites-enabled/vhosts-wildcard.conf:
  file.symlink:
    - target: {{ apache_conf_dir }}/sites-available/vhosts-wildcard.conf

enable-apache-modules:
  cmd.run:
    - name: 'a2enmod headers proxy proxy_http rewrite ssl vhost_alias'

{% elif grains['os_family'] == 'RedHat' %}
# RedHat-specific Apache config

# Main apache config file - httpd.conf
{{ apache_conf }}:
  file.managed:
    - source: salt://apache/redhat/httpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja

# TODO: RedHat wildcard vhost setup

{% endif %}

{{ apache_package }}:
  pkg.latest:
    - name: {{ apache_package }}
  service.running:
    - watch:
      - pkg: {{ apache_package }}
      - file: {{ apache_conf }}
      - file: /etc/php/7.0/apache2/php.ini  # currently only works on Debian-based systems; will error on RedHat
      {% if grains['os_family'] == 'Debian' %}
      - file: {{ apache_conf_dir }}/sites-enabled/vhosts-wildcard.conf
      - cmd: enable-apache-modules
      {% endif %}

# TODO: generate SSL certs for the server, using https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.tls.html


