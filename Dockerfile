FROM ubuntu:20.04

MAINTAINER Artemiy Sinitsyn <art@sinitsyn.info>

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
    apt-get -y install build-essential cmake autoconf libtool \
    pkg-config libgoogle-glog-dev libpcap-dev git \
    libssl-dev qtbase5-dev libboost-graph-dev libboost-system-dev \
    libboost-thread-dev libboost-coroutine-dev libboost-context-dev \
    libgoogle-perftools-dev curl wget iproute2 bash-completion \
    iputils-ping net-tools libevent-dev \
    nano vim iperf iperf3 tcpdump netcat sudo tmux

# install nodejs 10.x
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get -y install nodejs && \
    npm install uglify-js -g

WORKDIR /root

RUN apt-get -y install python3-pip && pip3 install six
RUN curl -O https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
#RUN apt-get -y install python2-pip && pip2 install six pytest requests simplejson && pip2 install .
#RUN sudo python2 get-pip.py && pip2 install six pytest request simplejson
RUN apt-get -y install python2 && pip install six 


# RUN apt -y install linux-headers-generic linux-generic # && cd /lib/modules/ &&  ln -s $(ls) $(uname -r)
RUN apt -y install apt-utils dkms

# RUN git clone https://github.com/openvswitch/ovs && \
#     cd ovs && ./boot.sh && \
#         ./configure && make -j4 && make install && \
#         cd .. && rm -rf ./ovs

RUN git clone https://github.com/mininet/mininet.git && cd mininet && ./util/install.sh -fnv

RUN apt -y install libboost-program-options-dev libedit-dev

RUN git clone https://github.com/fmtlib/fmt.git && cd fmt && mkdir build -p && cd build && cmake .. && make && make install

RUN pip3 install pytest requests simplejson
RUN pip2 install pytest requests simplejson

RUN apt -y install gdb

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /userdata

COPY bashrc.sh /etc/bashrc.sh
COPY entrypoint.sh /sbin/entrypoint.sh
COPY path.sh /etc/profile.d

ENTRYPOINT ["/sbin/entrypoint.sh"]
