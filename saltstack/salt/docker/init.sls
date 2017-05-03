docker.io:
  pkg.latest: []

docker:
  service.running:
    - require:
      - pkg: docker.io

docker_build_ssh:
  cmd.run:
    - name: 'docker build --tag honeyfarm/ssh - < /vagrant/Dockerfile-ssh'
    - require:
      - service: docker

docker_build_mysql:
  cmd.run:
    - name: 'docker build --tag honeyfarm/mysql - < /vagrant/Dockerfile-mysql'
    - require:
      - service: docker
