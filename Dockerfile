FROM rocker/tidyverse:latest
WORKDIR /workdir

COPY . /workdir

RUN Rscript -e "install.packages(c('covr', 'DT', 'htmltools', 'styler'), repos='http://cran.rstudio.com')"
RUN Rscript -e "pak::pkg_install('IslasGECI/testtools@v0.1.0')"

RUN Rscript -e "pak::pkg_install('IslasGECI/bycatch_code@latest')"
RUN make install
