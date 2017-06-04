FROM r-base

MAINTAINER "The pbdR Core Team" RBigData@gmail.com

RUN apt-get update \
  && apt-get install -y \
    libopenmpi-dev \
    libopenblas-dev \
    libzmq3-dev \
    littler \
    ssh \
    r-cran-curl


# some dependencies
RUN r -e 'install.packages(c("rlecuyer", "remotes"), repos="https://cran.rstudio.com/", dependencies="Imports")'


# install latest pbdR packages from github
RUN r -e "                                      \
  remotes::install_github('RBigData/pbdMPI')  ; \
  remotes::install_github('RBigData/pbdSLAP') ; \
  remotes::install_github('RBigData/pbdBASE') ; \
  remotes::install_github('RBigData/pbdDMAT') ; \
  remotes::install_github('RBigData/pbdML')     \
"


# create an R user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
  && chown -R user:user $HOME

WORKDIR $HOME
USER user


# some quality of life stuff
RUN echo "alias R='R --no-save --quiet'" >> /home/user/.bashrc


# default command
CMD ["bash"]
