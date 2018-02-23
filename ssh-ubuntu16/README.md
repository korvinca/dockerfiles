# dockerfiles-centos-ssh

# Building & Running

Copy the sources to your docker host and build the container:

	# docker build --rm -t <username>/ssh:ubuntu .

To run:

	# docker run -d -p 220:22 --name <name> <username>/ssh:ubuntu

Get the port that the container is listening on:

```
# docker ps
CONTAINER ID        IMAGE                 COMMAND             CREATED             STATUS              PORTS                   NAMES
8c82a9287b23        <username>/ssh:ubuntu   /usr/sbin/sshd -D   4 seconds ago       Up 2 seconds        0.0.0.0:220->22/tcp   <name>        
```

To test, use the port that was just located:

	# ssh -p 220 user@localhost 