/etc/audit/rules.d/honeypot.rules:
  file.managed:
    - source: salt://audit/files/honeypot.rules

auditd:
  pkg.latest: []
  service.running:
    - watch:
      - file: /etc/audit/rules.d/honeypot.rules
