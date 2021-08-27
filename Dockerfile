FROM node:12-buster-slim
MAINTAINER Daniel Sobe <daniel.sobe@sorben.com>

# docker build -t odas_web .
# docker build -t odas_web . --no-cache

RUN apt update

# COPY startme.sh /

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/developer

#    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#    chmod 0440 /etc/sudoers.d/developer && \
    
RUN apt install -y git libfftw3-dev libconfig-dev libasound2-dev libgconf-2-4 cmake g++ python

USER developer

ENV HOME /home/developer

RUN git clone https://github.com/ZalozbaDev/odas.git /home/developer/odas/

RUN cd /home/developer/odas/ && mkdir build && cd build && cmake .. && make

RUN git clone https://github.com/ZalozbaDev/odas_web.git /home/developer/odas_web/

RUN cd /home/developer/odas_web/ && CFLAGS=-Wno-error CPPFLAGS=-Wno-error npm install

# CMD /startme.sh

# run demo manually:
## docker run --privileged -it odas_web -w /home/developer/odas_web -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix /bin/sh
