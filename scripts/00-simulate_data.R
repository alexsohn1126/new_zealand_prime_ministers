#### Preamble ####
# Purpose: Simulates and Tests Birth/Death Years of Prime Ministers of New Zealand
# Author: Moohaeng Sohn
# Date: 3 February, 2024
# Contact: alex.sohn@mail.utoronto.ca
# License: MIT
# Pre-requisites: Download required Libraries


#### Workspace setup ####
library(tidyverse)
set.seed(203)

#### Simulate data ####
# 10 Random names for prime minister names
pm_names <- c("Alex",
              "Josh",
              "Helen",
              "David",
              "Victor",
              "Rob",
              "Emily",
              "Julia",
              "Michael",
              "Andrew")
simulated_data <- tibble(
  prime_minister = sample(pm_names, 10, replace = FALSE),
  birth_year = sample(1700:2005, 10, replace = TRUE), # Only people over 18 can become a PM, PM didn't exist before 1850s
  death_year = birth_year + sample(50:100, 10, replace = TRUE),
  years_lived = death_year - birth_year
)

#### Test Data ####
simulated_data$prime_minister |> is.character()

simulated_data$birth_year |> is.numeric()
all(simulated_data$birth_year >= 1700)
all(simulated_data$birth_year <= 2005)

simulated_data$death_year |> is.numeric()
all(simulated_data$death_year >= 1700)

simulated_data$years_lived |> is.numeric()
all(simulated_data$years_lived >= 18)
