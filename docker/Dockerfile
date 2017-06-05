FROM r-base
MAINTAINER "The pbdR Core Team" RBigData@gmail.com

RUN apt-get update \
  && apt-get install -y \
    libopenmpi-dev \
    libopenblas-dev \
    libzmq3-dev \
    littler \
    ssh \
    r-cran-curl \
    libnetcdf-dev \
    libsodium-dev \
    wget



# some CRAN dependencies
RUN r -e "install.packages(c('rlecuyer', 'remotes', 'getPass', 'png'), \
  'sodium', 'data.table', \
  repos='https://cran.rstudio.com/'', dependencies='Imports')"



# install latest pbdR packages from github
RUN r -e "                                        \
  remotes::install_github('RBigData/pbdMPI')    ; \
  remotes::install_github('RBigData/pbdSLAP')   ; \
  remotes::install_github('RBigData/pbdBASE')   ; \
  remotes::install_github('RBigData/pbdDMAT')   ; \
  remotes::install_github('RBigData/pbdML')     ; \
  remotes::install_github('RBigData/pmclust')   ; \
  remotes::install_github('RBigData/pbdRPC')    ; \
  remotes::install_github('RBigData/pbdZMQ')    ; \
  remotes::install_github('RBigData/remoter')   ; \
  remotes::install_github('RBigData/pbdCS')     ; \
  remotes::install_github('RBigData/pbdNCDF4')  ; \
  remotes::install_github('RBigData/pbdIO')     ; \
"



# create an R user
ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
  && chown -R user:user $HOME

WORKDIR $HOME
USER user

RUN mkdir /home/user/R
RUN mkdir /home/user/R/prof



# build profiler versions of pbdMPI and pbdDMAT
# TODO



# some quality of life stuff
RUN echo "alias R='R --no-save --quiet'" >> /home/user/.bashrc
RUN echo "options(repos=structure(c(CRAN='https://cran.rstudio.com/''))) ; \
  utils::rc.settings(ipck=TRUE); \
  " > /home/user/.Rprofile

RUN cd /tmp &&
  wget https://github.com/jalvesaq/colorout/archive/master.zip &&
  unzip master.zip &&
  R CMD INSTALL colorout-master/



# default command
CMD ["bash"]
