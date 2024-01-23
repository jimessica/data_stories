#### Preamble ####
# Purpose: Cleans the unedited fire inspection and ward data
# Author: Jessica Im
# Email: jessica.im@mail.utoronto.ca
# Date: 21 January 2024

#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(tidyverse)
library(knitr)
library(janitor)
library(lubridate)


#### Read in data ####
highrise_fire_inspection_data <-
  read_csv(
    "unedited_fire_inspection_data.csv",
    show_col_types = FALSE
  )

ward_data <-
  read_csv(
    "unedited_ward_data.csv",
    skip = 1358,
    show_col_types = FALSE
  )


#### Clean fire inspection data ####
# Clean names and filter out highrises without a violation
highrise_fire_inspection_clean <-
  clean_names(highrise_fire_inspection_data)|>
  drop_na(violation_fire_code)
head(highrise_fire_inspection_clean)


# Fix ward numbers so they are consistent
highrise_fire_inspection_clean <-
  highrise_fire_inspection_clean |>
  mutate(
    property_ward =
      case_match(
        property_ward,
        "01" ~ "1",
        "02" ~ "2",
        "03" ~ "3",
        "04" ~ "4",
        "05" ~ "5",
        "06" ~ "6",
        "07" ~ "7",
        "08" ~ "8",
        "09" ~ "9"
      )
  )


# Create a number of violations variable
highrise_fire_inspection_clean <-
  highrise_fire_inspection_clean |>
  group_by(property_address) |>
  mutate(number_of_violations = n())


# Only select the columns of importance
highrise_fire_inspection_clean <-
  highrise_fire_inspection_clean |>
  select(property_address,
         property_ward,
         violation_fire_code,
         violation_description,
         number_of_violations)
head(highrise_fire_inspection_clean)


# Save finalized data
write_csv(
  x = highrise_fire_inspection_clean,
  file = "highrise_fire_inspection_clean.csv",
)


#### Clean ward data ####
# Clean column names
ward_data_clean <-
  clean_names(ward_data)
ward_data_clean

# Select median household income data
ward_data_median_household_income <-
  ward_data_clean[25,3:27]
ward_data_median_household_income

# Select average monthly rented shelter cost
ward_data_avg_rent <-
  ward_data_clean[33,3:27]
ward_data_avg_rent

# Select average monthly owned shelter cost
ward_data_avg_owned_shelter_cost <-
  ward_data_clean[37,3:27]
ward_data_avg_owned_shelter_cost

# Select median individual income 
ward_data_median_indv_income <-
  ward_data_clean[69,3:27]
ward_data_median_indv_income


# Save ward data
write_csv(
  x = ward_data_clean,
  file = "ward_data_clean.csv",
)
