python:
  pkg.latest:
    - names:
      - python
      - python-pip
      - python3
      - python3-pip
{% if grains['os_family'] == 'RedHat' %}
      - mod_wsgi
      - python3-mod_wsgi
{% endif %}
