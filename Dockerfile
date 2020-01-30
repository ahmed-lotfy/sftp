FROM tech4health/t4h-os:ubuntu-19.10
MAINTAINER Ahmed Lotfy <alotfy@tech4health.io>

# Steps done in one RUN layer:
# - Install packages
# - OpenSSH needs /var/run/sshd to run
# - Remove generic host keys, entrypoint generates unique keys
RUN apt-get update && \
    apt-get install -y fail2ban && \
    apt-get -y install openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    rm -f /etc/ssh/ssh_host_*key*

COPY files/jail.local /etc/fail2ban/jail.local
COPY files/sshd_config /etc/ssh/sshd_config
COPY files/create-sftp-user /usr/local/bin/
COPY files/entrypoint /

#RUN systemctl start fail2ban
#RUN systemctl enable fail2ban

EXPOSE 22

ENTRYPOINT ["/entrypoint"]
