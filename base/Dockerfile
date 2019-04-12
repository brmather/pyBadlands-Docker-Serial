# Pull base image.
FROM ubuntu:18.04
LABEL maintainer="tristan.salles@sydney.edu.au"
LABEL repo="https://github.com/badlands-model"

# install things
RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        bash-completion \
        build-essential \
        apt-utils \
        git \
        python \
        python-dev \
        python-pip \
        xorg-dev \
        ssh \
        curl \
        libfreetype6-dev \
        libpng-dev \
        libtiff-dev \
        libxft-dev \
        xvfb \
        freeglut3 \
        freeglut3-dev \
        libgl1-mesa-dri \
        libgl1-mesa-glx \
        libavcodec-dev \
        libavformat-dev \
        libavutil-dev \
        libswscale-dev \
        rsync \
        vim \
        less \
        pkg-config \
        openmpi-bin \
        libhdf5-dev \
        liblapack-dev \
        llvm \
        libedit-dev \
        gfortran  \
        libsqlite3-dev \
        xauth && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN python2 -m pip install --upgrade pip && \
    python2 -m pip install --no-cache-dir \
        setuptools \
        netcdf4 && \
    python2 -m pip install --no-cache-dir \
        packaging \
        appdirs \
        numpy \
        jupyter \
        matplotlib==2.1.2. \
        runipy \
        pillow \
        enum34 \
        pyvirtualdisplay \
        scipy \
        Cython==0.20

RUN python2 -m pip install --no-cache-dir \
        markupsafe \
        zmq \
        singledispatch \
        backports_abc \
        certifi \
        jsonschema \
        path.py \
        git+https://github.com/badlands-model/triangle \
        pandas \
        plotly==2.7.0

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libnetcdf-dev \
    xauth && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN python2 -m pip install --no-cache-dir \
        h5py \
        numba==0.23.1 \
        ez_setup \
        colorlover \
        scikit-fuzzy \
        pyevtk \
        cmocean

# RUN python2 -m pip install 'ipython==4.2.0' --force-reinstall

RUN python2 -m pip install --no-cache-dir \
    git+https://github.com/matplotlib/legacycontour.git \
    git+https://github.com/awickert/gFlex.git \
    shapely \
    descartes


RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    wget \
    python-mpltoolkits.basemap
#\ python-pyproj \ libproj-dev \  proj-data \  proj-bin \ libgeos-dev \ libgdal-dev python-gdal gdal-bin
  
# basemap needs compilation :((
# though maybe you could 'pip install' it after setting the GEOS_DIR
# RUN wget http://downloads.sourceforge.net/project/matplotlib/matplotlib-toolkits/basemap-1.0.7/basemap-1.0.7.tar.gz && \
#     tar -zxvf basemap-1.0.7.tar.gz && \
#     cd basemap-1.0.7 && \
#     cd geos-3.3.3 && \
#     mkdir ~/install && \
#     ./configure --prefix=/usr/ && \
#     make && \
#     make install && \
#     export GEOS_DIR=/usr/ && \
#     cd .. && \
#     python setup.py build && \
#     python setup.py install && \
#     cd .. && \
#     rm -rf basemap-1.0.7.tar.gz && \
#     rm -rf basemap-1.0.7




# RUN apt-get update -qq && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
#     wget \
#     python-pyproj \
#     libproj-dev \
#     proj-data \
#     proj-bin \
#     libgeos-dev \
#     libgdal-dev \
#     python-gdal \
#     gdal-bin
  
# # basemap needs compilation :((
# # though maybe you could 'pip install' it after setting the GEOS_DIR
# RUN python2 -m pip install --no-cache-dir basemap



# install things
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    sqlite3 \
    xauth && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ^^^ Note we choose an older version of ipython because it's tooltips work better.
#     Also, the system six is too old, so we upgrade for the pip version

# Install Tini.. this is required because CMD (below) doesn't play nice with notebooks for some reason: https
#NOTE: If you are using Docker 1.13 or greater, Tini is included in Docker itself. This includes all versions of Docker CE. To enable Tini, just pass the --init flag to docker run.
RUN curl -L https://github.com/krallin/tini/releases/download/v0.6.0/tini > tini && \
    echo "d5ed732199c36a1189320e6c4859f0169e950692f451c03e7854243b95f4234b *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
chmod +x /usr/local/bin/tini

# script for xvfb-run.  all docker commands will effectively run under this via the entrypoint
RUN printf "#\041/bin/sh \n rm -f /tmp/.X99-lock && xvfb-run -s '-screen 0 1600x1200x16' \$@" >> /usr/local/bin/xvfbrun.sh && \
    chmod +x /usr/local/bin/xvfbrun.sh

# Add a notebook profile.
RUN mkdir -p -m 700 /root/.jupyter/ && \
    echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py


# expose notebook port
EXPOSE 8888

# expose LavaVu port
EXPOSE 9999


# note we also use xvfb which is required for viz
ENTRYPOINT ["/usr/local/bin/tini", "--", "xvfbrun.sh"]
