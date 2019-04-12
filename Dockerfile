FROM brmather/pybadlands-workshop-base:18.04-ubuntu

# set working directory to /build
WORKDIR /build

# setup environment
ENV PYTHONPATH $PYTHONPATH:/build/LavaVu

# Compile and install pyBadlands
RUN git clone https://github.com/badlands-model/pyBadlands_serial.git &&\
    mv /build/pyBadlands_serial /build/pyBadlands && \
    cd /build/pyBadlands/pyBadlands/libUtils && \
    make && \
    pip install --no-cache-dir -e /build/pyBadlands && \
    mkdir /home/jovyan && \
    mkdir /home/jovyan/examples && \
    mv /build/pyBadlands/Examples/* /home/jovyan/examples/

# Install companion
RUN git clone https://github.com/badlands-model/pyBadlands-Companion.git && \
    pip install --no-cache-dir -e /build/pyBadlands-Companion && \
    mkdir /home/jovyan/companion && \
    mv /build/pyBadlands-Companion/notebooks/* /home/jovyan/companion/


# get LavaVu and move notebooks
RUN git clone --branch "1.2.14" --single-branch https://github.com/OKaluza/LavaVu && \
    cd LavaVu && \
    ls -k src/sqlite3 && \
    pwd && \
    make LIBPNG=1 TIFF=1 VIDEO=1 -j4 && \
    rm -fr tmp && \
    mkdir /home/jovyan/LavaVu && \
    mv /build/LavaVu/notebooks /home/jovyan/LavaVu


# get all pyBadlands notebooks
RUN git clone https://github.com/badlands-model/pyBadlands-workshop.git && \
    mkdir /home/jovyan/workshop && \
    mv /build/pyBadlands-workshop/* /home/jovyan/workshop/


RUN useradd -ms /bin/bash jovyan && \
    chown -R jovyan:jovyan /home/jovyan

USER jovyan

# trust all notebooks
RUN find /home/jovyan -name \*.ipynb  -print0 | xargs -0 jupyter trust

# WORKDIR /build
# RUN git clone https://github.com/badlands-model/pyBadlands-workshop.git
# RUN cp -av /build/pyBadlands-workshop/* /home/jovyan/workshop/


# Trim some of the fat!
# RUN rm -rf /home/jovyan/workshop && \
    # rm -rf /home/jovyan/companion && \
    # rm -rf /home/jovyan/LavaVu

# # Copy test files to workspace
# RUN cp -av /build/pyBadlands/Examples/* /home/jovyan/examples/
# RUN cp -av /build/pyBadlands-Companion/notebooks/* /home/jovyan/companion/


# note we also use xvfb which is required for viz
ENTRYPOINT ["/usr/local/bin/tini", "--", "xvfbrun.sh"]

# setup space for working in
VOLUME /home/jovyan/volume

WORKDIR /home/jovyan

EXPOSE 8888
EXPOSE 9999


ENV LD_LIBRARY_PATH=/home/jovyan/volume/pyBadlands_serial/pyBadlands/libUtils:/build/pyBadlands/pyBadlands/libUtils

# launch notebook
CMD ["jupyter", "notebook", " --no-browser", "--allow-root", "--ip=0.0.0.0", "--NotebookApp.iopub_data_rate_limit=1.0e10"]

