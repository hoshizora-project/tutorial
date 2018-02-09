FROM continuumio/anaconda3:latest

LABEL maintainer='amaya <mail@sapphire.in.net>'

RUN set -eux && \
    apt update && \
    apt install -y \
      make clang libboost-all-dev libmecab-dev mecab-ipadic mecab-ipadic-utf8 unidic-mecab \
      libcurl4-openssl-dev libssl-dev libnuma1 libnuma-dev vim && \
    wget https://cmake.org/files/v3.10/cmake-3.10.2.tar.gz -O - | tar xz && \
    cd cmake-3.10.2 && \
    ./configure --system-curl && \
    make -j2 && \
    make install && \
    cd / && \
    rm -r cmake-3.10.2 && \
    conda install plotly && \
    conda install -c conda-forge python-igraph && \
    wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.15.tar.gz -O - | tar xz && \
    cd libiconv-1.15 && \
    ./configure && \
    make -j2 && \
    make install && \
    ldconfig && \
    git clone https://github.com/hoshizora-project/amanogawa.git /opt/amanogawa && \
    cd /opt/amanogawa && \
    make init && \
    python setup.py install && \
    git clone https://github.com/hoshizora-project/hoshizora.git /opt/hoshizora && \
    cd /opt/hoshizora && \
    git submodule init && \
    git submodule update && \
    python setup.py install

COPY data /root/sample

ENV LD_LIBRARY_PATH /opt/conda/lib/python3.6/site-packages/amanogawa-0.0.1a0-py3.6-linux-x86_64.egg

CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--NotebookApp.iopub_data_rate_limit=10000000000", "--NotebookApp.token="]
