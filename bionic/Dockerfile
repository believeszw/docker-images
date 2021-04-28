FROM ubuntu:18.04

# (see https://bugs.launchpad.net/cloud-images/+bug/1699913)
COPY ChangeLog.md /home/ 
COPY zsh/ /home/zsh
COPY shadowsocks/ /home/shadowsocks/

# make systemd-detect-virt return "docker"
# See: https://github.com/systemd/systemd/blob/aa0c34279ee40bce2f9681b496922dedbadfca19/src/basic/virt.c#L434
# cmatrix
RUN apt-get update && \
    apt-get install -y lsb-release zsh wget git iputils-ping screenfetch iputils-ping sudo vim curl \
    python-pip polipo libssl-dev netcat autoconf cmake tcptraceroute && \
    pip install shadowsocks && /home/zsh/install_zsh.sh && chsh -s /bin/zsh && echo "zsh" >> ~/.bashrc

COPY .vimrc /root/
COPY .zshrc /root/
COPY .gitconfig /root/
COPY openssl.py /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/
COPY config /etc/polipo/
CMD ["/bin/bash"]

