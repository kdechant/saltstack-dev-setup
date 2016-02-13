tools:
  pkg.latest:
    - names:
      - bzip2
      - curl
      - git
      - nano
      - wget
      - unzip
      - dnsmasq

# Manage global Git config.

/home/{{grains['id']}}/.gitconfig:
  file.managed:
    - source: salt://tools/.gitconfig
    - user: {{grains['id']}}
    - group: {{grains['id']}}
    - mode: 644

# Create .bashrc file if it doesn't exist
/home/{{grains['id']}}/.bashrc:
  file.managed:
    - user: {{grains['id']}}
    - group: {{grains['id']}}
    - mode: 644

# Dnsmasq config file
/etc/dnsmasq.d/dev-domains:
  file.managed:
    - source: salt://tools/dnsmasq-dev-domains
    - user: root
    - group: root
    - mode: 644

