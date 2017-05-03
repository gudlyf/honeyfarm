/usr/local/bin/honeypot-ssh.sh:
  file.managed:
    - source: salt://xinetd/files/honeypot-ssh.sh
    - user: root
    - group: root
    - mode: 0555
    - require:
      - pkg: xinetd

/usr/local/bin/honeypot-mysql.sh:
  file.managed:
    - source: salt://xinetd/files/honeypot-mysql.sh
    - user: root
    - group: root
    - mode: 0555
    - require:
      - pkg: xinetd

/etc/xinetd.d/honeypot-mysql:
  file.managed:
    - source: salt://xinetd/files/honeypot-mysql
    - user: root
    - group: root
    - mode: 0555
    - require:
      - pkg: xinetd

/etc/xinetd.d/honeypot-ssh:
  file.managed:
    - source: salt://xinetd/files/honeypot-ssh
    - user: root
    - group: root
    - mode: 0550
    - require:
      - pkg: xinetd

xinetd:
  pkg.latest: []
  service.running:
    - watch:
      - file: /etc/xinetd.d/honeypot-mysql
      - file: /etc/xinetd.d/honeypot-ssh
      - file: /usr/local/bin/honeypot-ssh.sh
      - file: /usr/local/bin/honeypot-mysql.sh
