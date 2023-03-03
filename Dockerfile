FROM islasgeci/base:1.0.0
COPY . /workdir

RUN Rscript -e "install.packages('rjson'), repos='http://cran.rstudio.com')"