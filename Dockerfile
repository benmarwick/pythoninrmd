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
  && sudo apt-get install software-properties-common -y \
  && sudo apt-add-repository universe y \
  # install Python
  && sudo apt install -y libpython3-dev python-pip  \
  && sudo pip install virtualenv \
  # install reticulate pkg  and set it up
  && R -e 'install.packages("remotes", repo = "https://cloud.r-project.org")' \
  && R -e 'remotes::install_github("rstudio/reticulate")' \
  && R -e 'reticulate::virtualenv_create()' \
  # install compendium pkg and build pkg and render vignettes
  && R -e "devtools::install('/pythoninrmd', dep=TRUE)" \
  && R -e "devtools::build('/pythoninrmd', vignettes = TRUE)"
