FROM rocker/tidyverse:latest
WORKDIR /workdir

COPY . /workdir

RUN Rscript -e "pak::pkg_install('IslasGECI/bycatch_code@latest')"
RUN Rscript -e "install.packages(c('covr', 'DT', 'htmltools', 'styler'), repos='http://cran.rstudio.com')"

RUN make install
