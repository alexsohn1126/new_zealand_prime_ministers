#### Preamble ####
# Purpose: Downloads and saves the data from New Zealand PM Wikipedia page
# Author: Moohaeng Sohn
# Date: 3 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download required Libraries


#### Workspace setup ####
library(tidyverse)
library(rvest)
library(xml2)

#### Download data ####
webscraped_page <-
  read_html(
    "https://en.wikipedia.org/wiki/List_of_prime_ministers_of_New_Zealand"
  )


#### Save data ####
write_html(webscraped_page, "inputs/data/NZ_PM_webscraped_page.html")

         
