FROM brmather/pybadlands-workshop-base:16.04-ubuntu

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
    mkdir /workspace && \
    mkdir /workspace/examples && \
    mv /build/pyBadlands/Examples/* /workspace/examples/

# Install companion
RUN git clone https://github.com/badlands-model/pyBadlands-Companion.git && \
    pip install --no-cache-dir -e /build/pyBadlands-Companion && \
    mkdir /workspace/companion && \
    mv /build/pyBadlands-Companion/notebooks/* /workspace/companion/


# get LavaVu and move notebooks
RUN git clone --branch "1.2.14" --single-branch https://github.com/OKaluza/LavaVu && \
    cd LavaVu && \
    ls -k src/sqlite3 && \
    pwd && \
    make LIBPNG=1 TIFF=1 VIDEO=1 -j4 && \
    rm -fr tmp && \
    mkdir /workspace/LavaVu && \
    mv /build/LavaVu/notebooks /workspace/LavaVu


# get all pyBadlands notebooks
RUN git clone https://github.com/badlands-model/pyBadlands-workshop.git && \
    mkdir /workspace/workshop && \
    mv /build/pyBadlands-workshop/* /workspace/workshop/

# trust all notebooks
RUN find /workspace -name \*.ipynb  -print0 | xargs -0 jupyter trust

# WORKDIR /build
# RUN git clone https://github.com/badlands-model/pyBadlands-workshop.git
# RUN cp -av /build/pyBadlands-workshop/* /workspace/workshop/


# Trim some of the fat!
# RUN rm -rf /workspace/workshop && \
    # rm -rf /workspace/companion && \
    # rm -rf /workspace/LavaVu

# # Copy test files to workspace
# RUN cp -av /build/pyBadlands/Examples/* /workspace/examples/
# RUN cp -av /build/pyBadlands-Companion/notebooks/* /workspace/companion/


# note we also use xvfb which is required for viz
ENTRYPOINT ["/usr/local/bin/tini", "--", "xvfbrun.sh"]

# setup space for working in
VOLUME /workspace/volume

WORKDIR /workspace


ENV LD_LIBRARY_PATH=/workspace/volume/pyBadlands_serial/pyBadlands/libUtils:/build/pyBadlands/pyBadlands/libUtils

# launch notebook
CMD ["jupyter", "notebook", " --no-browser", "--allow-root", "--ip=0.0.0.0", "--NotebookApp.iopub_data_rate_limit=1.0e10"]

