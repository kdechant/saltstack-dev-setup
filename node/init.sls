{% if grains['os'] == 'Mint' and grains['oscodename'] == 'rosa' %}
  {% set oscodename = 'trusty' %}
{% else %}
  {% set oscodename = grains['oscodename'] %}
{% endif %}

{%- if grains['os'] in ['Ubuntu', 'Debian', 'Mint'] %}
nodejs.ppa:
  pkg.installed:
    - name: apt-transport-https
    - require_in:
      - pkgrepo: nodejs.ppa
  pkgrepo.managed:
    - humanname: NodeSource Node.js Repository
    - name: deb https://deb.nodesource.com/node_5.x {{ oscodename }} main
    - dist: {{ oscodename }}
    - file: /etc/apt/sources.list.d/nodesource.list
    - keyid: "68576280"
    - key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    - keyserver: keyserver.ubuntu.com
    - require_in:
      pkg: nodejs
{%- endif %}

nodejs:
  pkg.installed

npm:
  pkg.installed:
    - require:
      - pkg: nodejs

node_tools:
  npm.installed:
    - names:
      - bower
      - grunt
      - gulp
    - require:
      - pkg: npm
