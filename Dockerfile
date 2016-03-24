FROM gazebo:libgazebo6
MAINTAINER Syo Amakase

# install gazebo packages
RUN apt-get update && apt-get install -q -y \
    build-essential \
    cmake \
    imagemagick \
    libboost-all-dev \
    libgts-dev \
    libjansson-dev \
    libtinyxml-dev \
    mercurial \
    nodejs \
    nodejs-legacy \
    npm \
    pkg-config \
    psmisc \
    git \
    && rm -rf /var/lib/apt/lists/*

# install gazebo packages
RUN apt-get update && apt-get install -q -y \
    libgazebo6-dev=6.5.1* \
    && rm -rf /var/lib/apt/lists/*

# clone gzweb
RUN hg clone https://bitbucket.org/osrf/gzweb ~/gzweb

# build gzweb
RUN cd ~/gzweb \
    && hg up default \
    && ./deploy.sh -m

# preparation to install anaconda
RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    mercurial \
    subversion \
    && rm -rf /var/lib/apt/lists/*

# install anaconda
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --no-check-certificate https://repo.continuum.io/archive/Anaconda-2.2.0-Linux-x86_64.sh && \
    /bin/bash Anaconda-2.2.0-Linux-x86_64.sh -b -p /opt/conda && \
    rm Anaconda-2.2.0-Linux-x86_64.sh

# setting env for conda
ENV PATH /opt/conda/bin:$PATH
ENV LANG C.UTF-8
ENV PYTHONPATH /opt/conda/python2.7/site-packages:$PYTHONPATH

# install xvfb
RUN apt-get update && apt-get install -q -y xvfb \
    && rm -rf /var/lib/apt/lists/*


# install pygazebo
RUN git clone https://github.com/jpieper/pygazebo.git ~/pygazebo \
    && cd ~/pygazebo \
    && git checkout 3eaac84 \
    && python setup.py install \
    && cd ../
