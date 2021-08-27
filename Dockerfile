FROM node:12-buster-slim
MAINTAINER Daniel Sobe <daniel.sobe@sorben.com>

# docker build -t odas_web .
# docker build -t odas_web . --no-cache

RUN apt update

# COPY startme.sh /

# Replace 1000 with your user / group id
#RUN export uid=1000 gid=1000 && \
#    mkdir -p /home/developer && \
#    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
#    echo "developer:x:${uid}:" >> /etc/group && \
#    chown ${uid}:${gid} -R /home/developer

#    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
#    chmod 0440 /etc/sudoers.d/developer && \
    
RUN apt install -y git libfftw3-dev libconfig-dev libasound2-dev libgconf-2-4 cmake g++ python

USER node

ENV HOME /home/node

RUN git clone https://github.com/ZalozbaDev/odas.git /home/node/odas/

RUN cd /home/node/odas/ && mkdir build && cd build && cmake .. && make

RUN git clone https://github.com/ZalozbaDev/odas_web.git /home/node/odas_web/

RUN cd /home/node/odas_web/ && CFLAGS=-Wno-error CPPFLAGS=-Wno-error npm install

USER root

RUN apt -y install libnss3 libgtk-3-0 libxss1 libx11-xcb1 

RUN chown root:root /home/node/odas_web/node_modules/electron/dist/chrome-sandbox
RUN chmod 4755 /home/node/odas_web/node_modules/electron/dist/chrome-sandbox

RUN apt install -y nano alsa-utils

# does not seem to work yet, so odaslive cannot be run inside container
RUN git clone https://github.com/ZalozbaDev/seeed-voicecard.git

RUN cp /seeed-voicecard/asound_4mic.conf /etc/asound.conf
RUN cp /seeed-voicecard/ac108_asound.state /var/lib/alsa/asound.state

USER node

# CMD /startme.sh

# run odas_web:
## docker run --privileged  -w /home/node/odas_web -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/pi/.Xauthority:/home/node/.Xauthority --net=host -it odas_web /bin/bash
## npm start &

## doesnt work yet
## ../odas/bin/odaslive -c ../odas/config/odaslive/respeaker_4_mic_array_custom.cfg 

## run on host:
## ../odas/bin/odaslive -c ../odas/config/odaslive/respeaker_4_mic_array_custom.cfg 
