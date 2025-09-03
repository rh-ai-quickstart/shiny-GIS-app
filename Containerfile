FROM docker.io/library/r-base:latest

LABEL maintainer="abanderb@redhat.com"
LABEL description="R runtime image for dashboard demo."
LABEL version="2.0"

USER root

RUN apt-get update && apt-get install -y libssl-dev libgdal-dev libgeos-dev libproj-dev libtbb-dev libnetcdf-dev libtool automake

RUN R -q -e 'install.packages(c("httpuv", "openssl","dplyr","httr","shiny", "shinyjs", "leaflet","RPresto", "DBI","tidyr"), repos = "https://cran.rstudio.com/")'

RUN mkdir -p /application/www 


COPY app.r /application
COPY www/icrc.png /application/www

WORKDIR /application

USER 1001

EXPOSE 8080

ENTRYPOINT R -s -e 'library("shiny"); runApp(host = "0.0.0.0", port = 8080)'
