# Base image https://hub.docker.com/u/rocker/
FROM rocker/r-ver:3.6.0

RUN apt-get update && apt-get install -y \
    sudo \
    gdebi-core \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    xtail \
    wget

# Download and install shiny server
RUN wget --no-verbose https://download3.rstudio.org/ubuntu-14.04/x86_64/VERSION -O "version.txt" && \
    VERSION=$(cat version.txt)  && \
    wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$VERSION-amd64.deb" -O ss-latest.deb && \
    gdebi -n ss-latest.deb && \
    rm -f version.txt ss-latest.deb && \
    . /etc/environment && \
    R -e "install.packages(c('shiny', 'rmarkdown'), repos='$MRAN')" && \
    cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ && \
    chown shiny:shiny /var/lib/shiny-server

## install debian packages
RUN add-apt-repository -y ppa:opencpu/imagemagick
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
	libxml2-dev \
	libcairo2-dev \
	libsqlite3-dev \
	libmariadbd-dev \
	libpq-dev \
	libssh2-1-dev \
	unixodbc-dev \
	libcurl4-openssl-dev \
	libssl-dev \
	libmagick++-dev

## install presentation R-packages
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "install.packages('summarytools')"
RUN Rscript -e "install.packages('readxl')"
RUN Rscript -e "install.packages('DT')"
RUN Rscript -e "install.packages('data.table')"
RUN Rscript -e "install.packages('dygraphs')" 
RUN Rscript -e "install.packages('formattable')"
RUN Rscript -e "install.packages('scales')" #
RUN Rscript -e "install.packages('shinycssloaders')"
RUN Rscript -e "install.packages('shinydashboard')"
RUN Rscript -e "install.packages('shiny')"
RUN Rscript -e "install.packages('shinyjs')"
RUN Rscript -e "install.packages('shinyWidgets')"
RUN Rscript -e "install.packages('tidyverse')"
RUN Rscript -e "install.packages('magrittr')"
RUN Rscript -e "install.packages('lubridate')"
RUN Rscript -e "install.packages('plotly')"
RUN Rscript -e "install.packages('vtreat')"
RUN Rscript -e "install.packages('xgboost')"
RUN Rscript -e "install.packages('skimr')"
RUN Rscript -e "install.packages('xts')"
RUN Rscript -e "install.packages('plotly')"
RUN Rscript -e "install.packages('forcats')"
RUN Rscript -e "install.packages('highcharter')"
RUN Rscript -e "install.packages('purrr')"

## install processing R-packages

RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('DataExplorer')"
RUN Rscript -e "install.packages('dplyr')"
RUN Rscript -e "install.packages('rpart')"
RUN Rscript -e "install.packages('rpart.plot')"
RUN Rscript -e "install.packages('rattle')"
RUN Rscript -e "install.packages('Metrics')"
RUN Rscript -e "install.packages('ipred')"
RUN Rscript -e "install.packages('caret')"
RUN Rscript -e "install.packages('randomForest')"
RUN Rscript -e "install.packages('magick')"
RUN Rscript -e "install.packages('httr')"
RUN Rscript -e "install.packages('jsonlite')"
RUN Rscript -e "install.packages('RMySQL')"
RUN Rscript -e "install.packages('DBI')"
RUN Rscript -e "install.packages('aws.s3')"
RUN Rscript -e "install.packages('glue')"
RUN Rscript -e "install.packages('summarytools')"


## create directories
RUN mkdir -p /01_input ; \
    mkdir -p /02_code ; \
	ln -s /tmp /03_staging ; \
	mkdir -p /04_output ; \
	mkdir -p /05_logs ;\
	rm -r /srv/shiny-server 


## copy files
COPY shiny-server.conf /etc/shiny-server/shiny-server.conf
COPY shiny-server.sh /usr/bin/shiny-server.sh
RUN chmod +x /usr/bin/shiny-server.sh

## Expose shiny port ##
EXPOSE 3838
