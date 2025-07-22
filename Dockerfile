FROM islasgeci/bycatch:latest
COPY . /workdir

RUN R -e "remotes::install_github('IslasGECI/bycatch_code', ref='latest', upgrade='never')"

RUN make install
