```
docker stop devbox || true
docker rm devbox || true
echo "DO A PRUNE? YOU MAY WANT TO SAY NO."
docker system prune
docker pull ubuntu
docker build --tag devbox .
docker run -dit --name devbox devbox
docker exec -it devbox zsh
```
