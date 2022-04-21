FROM ivonet/ubuntu:22.04

LABEL maintainer="@ivonet"

ENV USER_NAME=ivonet \
    PS1='\u $(pwd) > '

# add local files
COPY root /

RUN apt-get update -y --no-install-recommends \
 && apt-get install -y --no-install-recommends   \
    sudo \
	openssh-server \
	openssh-sftp-server \
 && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config \
 && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
 && sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config \
 && usermod --shell /bin/bash abc \
 && chmod +x /etc/cont-init.d/* \
 && chmod -Rv +x /etc/services.d/ \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /tmp/* \
 && chmod -Rv -x /etc/update-motd.d/

EXPOSE 22
