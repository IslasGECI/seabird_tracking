FROM rocker/tidyverse:latest
WORKDIR /workdir

COPY . /workdir

RUN R -e "pak::pkg_install('IslasGECI/bycatch_code@latest')"

RUN make install
