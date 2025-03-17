docker stop unbound-app
docker build -t unbound .
docker-compose up -d --force-recreate
