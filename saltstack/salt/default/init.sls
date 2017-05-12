iptables:
  pkg.latest: []
socat:
  pkg.latest: []
salt-minion:
  service.dead: []

/var/log/script:
  file.directory:
    - user: root
    - group: root
    - mode: 660
    - makedirs: True
