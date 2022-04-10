FROM ivonet/alpine-base:3.15

LABEL maintainer="@ivonet"

ENV USER_NAME=ivonet \
    PS1='\u $(pwd) > '

# add local files
COPY root /

RUN apk add --no-cache --upgrade \
	sudo \
	openssh-server \
	openssh-sftp-server \
 && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
 && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config \
 && usermod --shell /bin/bash abc \
 && rm -rf /tmp/* \
 && chmod +x /etc/cont-init.d/* \
 && chmod -Rv +x /etc/services.d/

EXPOSE 22
