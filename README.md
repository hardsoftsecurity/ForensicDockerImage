# Forensic Docker Image

The idea of this project is to provide with the posibility to have a docker image with forensic tools and use them whitout the necessity of installing them on our own machines.

I will keep update the image with new tools but just when I learn how to use it. Also, the idea of this docker image is to use it on my daily basis as Security Analyst.

## Instructions for running the tools and sharing files

First of all we will need to install docker on our system. We can follow the instructions on the official documentation:
https://docs.docker.com/engine/install/


Check that everything is alright with the Dockerfile.


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
sudo docker run --rm -v /path/to/pcaps:/home/analyst/pcaps forensic-tools:ubuntu22
```

### Enable X11 to be able to run the GUI of the tools:
- Run the following command:

```bash
sudo xhost +local:docker  # Allow GUI access for Docker
```

### Wireshark: 
- Run with 

```bash
sudo docker run --rm -e DISPLAY=$DISPLAY -v /path/to/pcaps:/home/analyst/pcaps -v /tmp/.X11-unix:/tmp/.X11-unix forensic-tools:ubuntu22 wireshark
```

### Zui: 
- Run with 

```bash
sudo docker run --rm -e DISPLAY=$DISPLAY -v /path/to/pcaps:/home/analyst/pcaps -v /tmp/.X11-unix:/tmp/.X11-unix forensic-tools:ubuntu22 zui
```

### NetworkMiner: 
- Run with 

```bash
sudo docker run --rm -e DISPLAY=$DISPLAY -v /path/to/pcaps:/home/analyst/pcaps -v /tmp/.X11-unix:/tmp/.X11-unix forensic-tools:ubuntu22 mono /opt/networkminer/NetworkMiner.exe
```

### NFDump: 
- Run with 

```bash
sudo docker run --rm -v /path/to/pcaps:/home/analyst/pcaps forensic-tools:ubuntu22 nfdump
```

### Zeek: 
- Run with 

```bash
sudo docker run --rm -v /path/to/pcaps:/home/analyst/pcaps forensic-tools:ubuntu22 zeek
```

### RITA: 
- Run with 

```bash
sudo docker run --rm -v /path/to/pcaps:/home/analyst/pcaps forensic-tools:ubuntu22 rita
```

### Suricata: 
- Run with 

```bash
sudo docker run --rm -v /path/to/pcaps:/home/analyst/pcaps forensic-tools:ubuntu22 suricata
```

## Extra

Feel free to suggest anything new or if you are missing something here.

I hope you like the solution!