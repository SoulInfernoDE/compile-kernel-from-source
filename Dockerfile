# Pull base image.
FROM ubuntu:22.04

# Make sure APT operations are non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Add basic tools
RUN apt update >/dev/null
RUN apt install -y wget curl gnupg ccrypt locales unzip libfile-fcntllock-perl rsync apt-utils >/dev/null

# Set locale
RUN echo "de_DE.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen
ENV LANG de_DE.UTF-8
ENV LANGUAGE de_DE:de
ENV LC_ALL de_DE.UTF-8

# Add GHR
RUN \
   wget https://github.com/tcnksm/ghr/releases/download/v0.5.4/ghr_v0.5.4_linux_amd64.zip 2>/dev/null \
&& unzip ghr_v0.5.4_linux_amd64.zip \
&& mv ghr /usr/bin/ghr \
&& rm ghr_v0.5.4_linux_amd64.zip

# Add files.
ADD mint21.2 /
ADD nogui/cfs_noguimerge.sh /
ADD config/config ~/Downloads/kernel/.config
RUN chmod +x /cfs_noguimerge.sh

###################################
# Set up repositories
###################################

# Add linuxmint-keyring
RUN \
   wget http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb 2>/dev/null \
&& dpkg -i linuxmint-keyring_2016.05.26_all.deb \
&& rm linuxmint-keyring_2016.05.26_all.deb

# Empty default sources.list
RUN echo "" > /etc/apt/sources.list

# Update APT cache.
RUN apt update >/dev/null

###################################
# Apply updates
###################################

RUN apt dist-upgrade -y >/dev/null

###################################
# Install stuff
###################################

RUN apt install -y mint-dev-tools build-essential devscripts fakeroot quilt dh-make automake libdistro-info-perl less nano ubuntu-dev-tools python3 pip >/dev/null

###########################################
# run the docker compile from source script
###########################################

RUN /cfs_noguimerge.sh

####################################
# install uploader stuff
####################################

RUN curl "https://raw.githubusercontent.com/andreafabrizi/Dropbox-Uploader/master/dropbox_uploader.sh" -o /usr/bin/dbu \
&&  chmod +x /usr/bin/dbu \
&&  wget -P ~/ https://github.com/SoulInfernoDE/compile-kernel-from-source/raw/dockercompile/nogui/dropbox_uploader.cpt \
&&  ccrypt -dE LC_ALL ~/.dropbox_uploader.cpt

####################################
# upload compiled stuff (deb-files)
####################################

RUN dbu mkdir $KERNEL_VERSION \
&&  dbu upload $HOME/Downloads/* $KERNEL_VERSION
