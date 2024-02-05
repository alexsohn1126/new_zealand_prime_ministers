#### Preamble ####
# Purpose: Tests Cleaned New Zealand PM data
# Author: Moohaeng Sohn
# Date: 4 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download required Libraries, run 01-download_data.R, 02-data_cleaning.R


#### Workspace setup ####
library(tidyverse)

#### Test data ####
cleaned_data <- read_csv("outputs/data/cleaned_NZ_PM_data.csv")

cleaned_data$prime_minister |> is.character()

cleaned_data$birth_year |> is.numeric()
all(cleaned_data$birth_year >= 1700)
all(cleaned_data$birth_year <= 2005)

cleaned_data$death_year |> is.numeric()
all(is.na(cleaned_data$death_year) | cleaned_data$death_year >= 1700)
# Had to add is.na for cases when PMs didn't die yet, same for years_lived below

cleaned_data$years_lived |> is.numeric()
all(is.na(cleaned_data$years_lived) | cleaned_data$years_lived >= 18)
