# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.6.0

# required
MAINTAINER Your Name <your_email@somewhere.com>

COPY . /<REPO>

# go into the repo directory
RUN . /etc/environment \
  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \
  # instally Python and reticulate pkg
  && sudo apt install -y python3-venv python3-pip python3-virualenv \
  &&  R -e 'install.packages("remotes", repo = "https://cloud.r-project.org")' -e 'remotes::install_github("rstudio/reticulate")' \
  && -e 'reticulate::virtualenv_create()' \
  # install compendium pkg and build pkg and render vignettes
  && R -e "devtools::install('/pythoninrmd', dep=TRUE)" \
  && R -e "devtools::build('/pythoninrmd', vignettes = TRUE)"
