FROM ivonet/alpine-base:3.13

# set version label
ARG OPENSSH_RELEASE=8.4_p1-r2
LABEL maintainer="@ivonet"

ENV USER_NAME=ivonet \
    PS1='$(pwd) > '

RUN \
 echo "**** install runtime packages ****" && \
 apk add --no-cache --upgrade \
	curl \
	logrotate \
	nano \
	vim \
	sudo && \
 echo "**** install openssh-server ****" && \
 if [ -z ${OPENSSH_RELEASE+x} ]; then \
	OPENSSH_RELEASE=$(curl -s http://dl-cdn.alpinelinux.org/alpine/v3.13/main/x86_64/ \
	| awk -F '(openssh-server-|.apk)' '/openssh-server.*.apk/ {print $2; exit}'); \
 fi && \
 apk add --no-cache \
	openssh-server==${OPENSSH_RELEASE} \
	openssh-sftp-server==${OPENSSH_RELEASE} && \
 echo "**** setup openssh environment ****" && \
 sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config && \
 usermod --shell /bin/bash abc && \
 rm -rf \
	/tmp/*

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config

# add local files
COPY root /

EXPOSE 22
