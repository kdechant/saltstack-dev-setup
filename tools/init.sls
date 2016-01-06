tools:
  pkg.latest:
    - names:
      - bzip2
      - curl
      - git
      - nano
      - wget
      - unzip

# Manage global Git config.

/home/{{grains['id']}}/.gitconfig:
  file.managed:
    - source: salt://tools/.gitconfig
    - user: {{grains['id']}}
    - group: {{grains['id']}}
    - mode: 644


