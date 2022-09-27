# Pull base image.
FROM ubuntu:22.04

LABEL maintainer="Julien Ancelin<https://github.com/jancelin>"

LABEL org.label-schema.schema-version = "1.0"
LABEL org.label-schema.version = "QGIS_3.27"
LABEL org.label-schema.description = "QGIS 3.27.x docker"

LABEL org.label-schema.url="http://rafdouglas.science"
LABEL org.label-schema.vcs-url = "https://github.com/jancelin"
LABEL org.label-schema.docker.cmd = "sh ./qgis_run.sh"


# Install the bases and upgrade the system
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  export DEBIAN_FRONTEND=noninteractive && \
  export DEBIAN_FRONTEND="noninteractive" TZ="Europe/Rome" && apt-get install -y tzdata && \
  export DEBIAN_FRONTEND="noninteractive" && apt-get install -y keyboard-configuration && \
  apt-get install -y build-essential gnupg && \
  apt-get install -y software-properties-common && \
  rm -rf /var/lib/apt/lists/*

#Install preliminary files
RUN \
  apt-get update && \
  #export DEBIAN_FRONTEND=noninteractive && \
  #DEBIAN_FRONTEND="noninteractive" TZ="Europe/Paris" apt-get install -y tzdata && \
  #apt-get install -y tzdata && \
  #/bin/ln -sf /usr/share/zoneinfo/Etc/Zulu  /etc/localtime && \
  #dpkg-reconfigure --frontend noninteractive tzdata && \
  apt-get -y install ca-certificates apt-utils wget

RUN \
mkdir -m755 -p /etc/apt/keyrings && \
wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg

COPY qgis.sources /etc/apt/sources.list.d/qgis.sources

RUN \
  apt-get update && \
  apt-get install -y  python3-pyqt5.qtxmlpatterns && \
  apt-get install -y  python3-qgis qgis qgis-plugin-grass
#RUN \
#  apt-get remove -y --purge cmake-data && \
#  apt-get remove -y --purge libqt4* libgtk* libsane *gnome* libsane *pango* glib* *gphoto* && \
#  apt-get remove -y --purge build-essential gnupg software-properties-common apt-utils wget && \
#  apt-get clean

#Create directories to be used
RUN \
  mkdir -p /root/ && \
  mkdir -p /root/qgis-docker-files

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

# Define default command.
#CMD ["find", "/","-name","qgis"]
CMD ["qgis"]
