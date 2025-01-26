# Forensic Docker Image

The idea of this project is to provide with the posibility to have a docker image with forensic tools and use them whitout the necessity of installing them on our own machines.

I will keep update the image with new tools but just when I learn how to use it. Also, the idea of this docker image is to use it on my daily basis as Security Analyst.

## Instructions for running the docker image.

First of all we will need to install docker on our system. We can follow the instructions on the official documentation:
https://docs.docker.com/engine/install/

Compile the image:

```bash
sudo docker build -t forensic-tools:ubuntu22 .
```

We can check the if the image was successfully compiled checking the list of images compiled:
```bash
sudo docker images
```

Then, we can run the container with a shared folder where we will place our files to being analyzed:

```bash
sudo docker run -dit --name forensic-tools \
    -v /home/user/ForensicArtifacts:/home/analyst/artifacts \
    forensic-tools:ubuntu22
```
-d: Runs the container in detached mode.
-it: Allocates a pseudo-TTY and keeps the STDIN open, allowing interactive usage.
--name forensic-tools: Assigns a name to the container for easy reference.
-v: Mounts a volume for persistent storage.

### Reconnect to a Stopped Container

If the container stops, you can restart it and reattach:
Restart the Container:

```bash
docker start forensic-tools
```

Reattach to the Container:

```bash
docker attach forensic-tools
```

Or Open a New Shell:

```bash
docker exec -it forensic-tools /bin/bash
```

### Enable X11 to be able to run the GUI of the tools:
- Run the following command:

```bash
sudo xhost +local:docker  # Allow GUI access for Docker
```

## Instructions for running the tools and sharing files

### Wireshark: 
- Run with 

```bash
sudo docker run --rm -e DISPLAY=$DISPLAY -v /home/david/ForensicArtifacts:/home/analyst/artifacts -v /tmp/.X11-unix:/tmp/.X11-unix forensic-tools:ubuntu22 wireshark
```

### Zui: 
- Run with 

```bash
sudo docker run --rm -e DISPLAY=$DISPLAY \
    -v /home/david/ForensicArtifacts:/home/analyst/artifacts \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --security-opt apparmor=unconfined \
    --privileged \
    forensic-tools:ubuntu22 \
    bash -c "sudo service dbus start && zui --no-sandbox --disable-gpu --disable-software-rasterizer"
```

### NetworkMiner: 
- Run with 

```bash
sudo docker run --rm -e DISPLAY=$DISPLAY -v /home/david/ForensicArtifacts:/home/analyst/artifacts -v /tmp/.X11-unix:/tmp/.X11-unix forensic-tools:ubuntu22 mono /opt/networkminer/NetworkMiner_2-9/NetworkMiner.exe
```

### NFDump: 
- Run with 

```bash
sudo docker run --rm -v /home/david/ForensicArtifacts:/home/analyst/artifacts forensic-tools:ubuntu22 nfdump
```

### Zeek: 
- Run with 

```bash
sudo docker run --rm -v /home/david/ForensicArtifacts:/home/analyst/artifacts forensic-tools:ubuntu22 zeek
```

### RITA: 
- Run with 

```bash
sudo docker run --rm -v /home/david/ForensicArtifacts:/home/analyst/artifacts forensic-tools:ubuntu22 rita
```

### Suricata: 
- Run with 

```bash
sudo docker run --rm -v /home/david/ForensicArtifacts:/home/analyst/artifacts forensic-tools:ubuntu22 suricata
```

## Extra

Feel free to suggest anything new or if you are missing something here.

I hope you like the solution!