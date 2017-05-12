docker.io:
  pkg.latest: []

docker:
  service.running:
    - require:
      - pkg: docker.io

docker_build_ssh:
  cmd.run:
    - name: 'docker build --tag honeyfarm/ssh -f /vagrant/dockerfiles/Dockerfile-ssh .'
    - cwd: /vagrant/dockerfiles
    - require:
      - service: docker

docker_pull_mysql:
  cmd.run:
    - name: 'docker pull mysql:5.7'
    - require:
      - service: docker

#docker_build_mysql:
#  cmd.run:
#    - name: 'docker build --tag honeyfarm/mysql -f /vagrant/dockerfiles/Dockerfile-mysql .'
#    - cwd: /vagrant/dockerfiles
#    - require:
#      - service: docker
