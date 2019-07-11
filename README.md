# docker-ml-base

Docker & Docker-Compose files for running basic machine learning tools.

- Jupyter interface only
- Terminal is available on the jupyter

## Tools available on this docker

- Ubuntu 16.04 based
- Anaconda3-2019.03-Linux-x86_64
- Pytorch & torchvision
- Tensorflow
- Jupyter notebook
- Matplotlib, pandas, and so on
- Openpyxl
- FastText
- Mecab, neologdn, and LANG=ja_JP.UTF-8
- dl-cliche

## Running service

Build the image:

> docker-compose build

Then run:

> docker-compose up

Open localhost:8888 to start jupyter.

## Setup details

- Base folder: /data

## Todos

- [ ] Rename base folder
- [ ] Fast.ai
