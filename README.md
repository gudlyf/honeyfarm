# honeyfarm
Multipurpose honeypot within Docker environment. Based off Dockerpot (https://github.com/mrschyte/dockerpot).

To run (works on MacOS):

docker run -d -p 3306:3306 -p 2222:22 --name honeypot-entrypoint -e DOCKER_HOST=$DOCKER_HOST honeyfarm/entrypoint
