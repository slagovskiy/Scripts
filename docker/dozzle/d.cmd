docker run --name dozzle -d --volume=/var/run/docker.sock:/var/run/docker.sock -p 9001:8080 amir20/dozzle:latest