```
docker pull ubuntu
docker build --tag devbox .
docker volume rm projects
docker volume create projects
docker run -p ....:.... --mount type=bind,src=...,dst=/mnt --mount type=volume,src=projects,dst=/projects -dit --name devbox devbox
docker exec -it devbox bash
```
