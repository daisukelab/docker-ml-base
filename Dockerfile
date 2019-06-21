FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y wget bzip2 libgtk2.0-0

# Anaconda3
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh && \
    bash Anaconda3-2019.03-Linux-x86_64.sh -b && \
    rm -f Anaconda3-2019.03-Linux-x86_64.sh

ENV PATH $PATH:/root/anaconda3/bin

# OpenCV
RUN conda install -c https://conda.anaconda.org/menpo opencv3


# Anaconda jupyter
RUN conda config --add channels conda-forge
RUN conda install nb_conda -y && conda install obspy -y
RUN conda install jupyter -y --quiet 
RUN conda install -c conda-forge jupyter_contrib_nbextensions && jupyter contrib nbextension install --user 
RUN rm -rf /root/.local/share/jupyter/nbextensions  

# Pytorch and tensorflow
RUN conda install pytorch torchvision -c pytorch
RUN pip install tensorboardX
RUN pip install tensorflow

# Other essential tools
RUN apt-get install -y emacs
RUN pip install dateutils
RUN pip install easydict
RUN apt-get install -y git cmake swig
RUN apt-get install -y build-essential
RUN pip install matplotlib
RUN pip install pandas
RUN pip install tqdm
RUN pip install imbalanced-learn
RUN pip install openpyxl
RUN pip install xlrd
RUN pip install neologdn
RUN git clone https://github.com/facebookresearch/fastText.git
RUN mkdir /fastText/build && cd /fastText/build && cmake .. && make && make install
RUN cd /fastText && pip install .
RUN apt-get install -y mecab libmecab-dev mecab-ipadic-utf8 git make curl xz-utils file
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
RUN cd mecab-ipadic-neologd && ./bin/install-mecab-ipadic-neologd -n -y -p /var/lib/mecab/dic/mecab-ipadic-neologd
RUN pip install mecab-python3 neologdn

RUN git clone https://github.com/daisukelab/dl-cliche.git
RUN cd dl-cliche && pip install . --upgrade

# Set localtime
RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# Set jupyter token
# '12345' = sha1:e789dbb501a8:88e6ae6f7664712085dc92fadd89f1d6558893ad
RUN jupyter notebook --generate-config
RUN sed -i "s/#c.NotebookApp.password = ''/c.NotebookApp.password = 'sha1:e789dbb501a8:88e6ae6f7664712085dc92fadd89f1d6558893ad'/" /root/.jupyter/jupyter_notebook_config.py
#RUN grep "c.NotebookApp.password" /root/.jupyter/jupyter_notebook_config.py

# https://qiita.com/Mahoutukai_sali/items/a1fef9684bdcc907c3f3
# 日本語の扱いを可能にする
RUN apt-get update && apt-get install -y language-pack-ja-base language-pack-ja 
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8

# Run jupyter
EXPOSE 8888
WORKDIR /data
CMD jupyter notebook --notebook-dir=/data --ip='0.0.0.0' --port=8888 --no-browser --allow-root
