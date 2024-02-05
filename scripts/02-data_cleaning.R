#### Preamble ####
# Purpose: Cleans the raw html file of prime ministers in New Zealand
# Author: Moohaeng Sohn
# Date: 4 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download required Libraries, run 01-download_data.R

#### Workspace setup ####
library(tidyverse)
library(rvest)
library(xml2)

#### Clean data ####
raw_page <- read_html("inputs/data/NZ_PM_webscraped_page.html")

wikitables <-
  raw_page |>
  html_elements(".wikitable")

# Only select column with name and year of birth and death
first_raw_data <-
  wikitables[[1]] |>
  html_table() |>
  select(raw = "NameConstituency(Birth–Death)") |>
  filter(raw != "NameConstituency(Birth–Death)")

# Remove whatever prefix "the honourable" or "the right honourable" that comes 
# before the name, also the "Sir" prefix
first_raw_data$raw <- 
  first_raw_data$raw |> 
  str_remove_all("The .*Honourable") |>
  str_remove_all("Sir ")
  

# the hyphen used in wikipedia seems to be a special type of hyphen.. 
# – <- here is the one used by wikipedia
first_cleaned_data<-
  first_raw_data |>
  mutate(
    dates = unlist(str_extract_all(first_raw_data$raw, "\\d{4}–\\d{4}")),
    # match 4 digits, followed by weird hyphen, then another 4 digits
    prime_minister = unlist(str_extract_all(first_raw_data$raw, "^.+?(?=[A-Z]{2,}|Bt|Councillor)"))
    # match everything until more than 2 capital letters show up in sequence
    # Name of PMs are before the titles they owned, or "MP for..."
    # therefore there's always 2 capital letters before the name 
    # EXCEPT for Bt and Councillor title, so we add another option for that in regex
    # Regex inspired by https://stackoverflow.com/a/7124976
  ) |>
  separate(dates, into = c("birth_year", "death_year"), convert = TRUE) |>
  mutate(
    years_lived = death_year - birth_year
  ) |>
  select(prime_minister, birth_year, death_year, years_lived)

# Now do the same for the second wikitable
second_raw_data <-
  wikitables[[2]] |>
  html_table() |>
  select(raw = "NameConstituency(Birth–Death)") |>
  filter(raw != "NameConstituency(Birth–Death)")

second_raw_data$raw <- 
  second_raw_data$raw |> 
  str_remove_all("The .*Honourable") |>
  str_remove_all("Sir ")

second_cleaned_data<-
  second_raw_data |>
  mutate(
    dates = unlist(str_extract_all(second_raw_data$raw, "(\\d{4}–\\d{4})|((?<=born )\\d{4})")),
    # Here, because some PMs are still alive, we add additional condition
    # Inspired by https://stackoverflow.com/a/7124976
    prime_minister = unlist(str_extract_all(second_raw_data$raw, "^.+?(?=[A-Z]{2,}|Bt|Councillor)"))
  ) |>
  separate(dates, into = c("birth_year", "death_year"), convert = TRUE) |>
  mutate(
    years_lived = death_year - birth_year
  ) |>
  select(prime_minister, birth_year, death_year, years_lived)

# Combine  those two tibbles
cleaned_table <- bind_rows(first_cleaned_data, second_cleaned_data) |>
  distinct()

#### Save data ####
write_csv(cleaned_table, "outputs/data/cleaned_NZ_PM_data.csv")
