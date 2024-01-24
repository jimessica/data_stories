#### Preamble ####
# Purpose: Clean the unedited fire inspection and ward data
# Author: Jessica Im
# Email: jessica.im@mail.utoronto.ca
# Date: 24 January 2024


#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(tidyverse)
library(knitr)
library(janitor)
library(lubridate)


#### Read in data ####
# Read in fire data
highrise_fire_inspection_data <-
  read_csv(
  "inputs/data/unedited_fire_inspection_data.csv",
  show_col_types = FALSE
  )

# Read in ward data
ward_data_economics <-
  read_csv(
  "inputs/data/unedited_ward_data.csv",
  skip = 1358,
  show_col_types = FALSE
  )

ward_data <-
  read_csv(
    "inputs/data/unedited_ward_data.csv",
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
        "09" ~ "9",
        "10" ~ "10",
        "11" ~ "11",
        "12" ~ "12",
        "13" ~ "13",
        "14" ~ "14",
        "15" ~ "15",
        "16" ~ "16",
        "17" ~ "17",
        "18" ~ "18",
        "19" ~ "19",
        "20" ~ "20",
        "21" ~ "21",
        "22" ~ "22",
        "23" ~ "23",
        "24" ~ "24",
        "25" ~ "25",
      )
  )
head(highrise_fire_inspection_clean)



# Create a dataset with number of violations per ward
# Based on code from: https://www.geeksforgeeks.org/remove-duplicate-rows-based-on-multiple-columns-using-dplyr-in-r/
highrise_fire_inspection_clean_ward <-
  highrise_fire_inspection_clean |>
  select(property_ward,
         violation_fire_code)
highrise_fire_inspection_clean_ward

highrise_fire_inspection_clean_ward <-
  highrise_fire_inspection_clean_ward |>
  group_by(property_ward) |>
  mutate(number_of_violations_per_ward = n()) |>
  select(property_ward,
        number_of_violations_per_ward)
highrise_fire_inspection_clean_ward

highrise_fire_inspection_clean_ward <-
  distinct(highrise_fire_inspection_clean_ward, property_ward, .keep_all= TRUE)
highrise_fire_inspection_clean_ward


# Create a cleaned dataset with all relevant columns
highrise_fire_inspection_clean_all <-
  highrise_fire_inspection_clean |>
  group_by(property_address) |>
  mutate(number_of_violations = n())
highrise_fire_inspection_clean_all

# Only select the columns of importance
highrise_fire_inspection_clean_all <-
  highrise_fire_inspection_clean_all |>
  select(property_address,
         property_ward,
         violation_fire_code,
         number_of_violations)
head(highrise_fire_inspection_clean_all)

#### Save finalized comprehensive data ####
write_csv(
  x = highrise_fire_inspection_clean_all,
  file = "inputs/data/highrise_fire_inspection_clean_all.csv"
)

#### Save finalized ward-specific data ####
write_csv(
  x = highrise_fire_inspection_clean_ward,
  file = "inputs/data/highrise_fire_inspection_clean_ward.csv"
)


#### Clean ward data ####
# Clean column names and remove toronto column
ward_data_clean <-
  clean_names(ward_data_economics) |>
  rename(data_type = na)
ward_data_clean

ward_data_clean <-
  ward_data_clean[-c(2)]
ward_data_clean


# Select median household income data
ward_data_median_household_income <-
  ward_data_clean[25,]
ward_data_median_household_income

# Select average monthly rented shelter cost
ward_data_avg_rent <-
  ward_data_clean[33,]
ward_data_avg_rent

# Select average monthly owned shelter cost
ward_data_avg_owned_shelter_cost <- 
  ward_data_clean[37,]
ward_data_avg_owned_shelter_cost

# Select median individual income 
ward_data_median_indv_income <- 
  ward_data_clean[69,]
ward_data_median_indv_income

# Bind ward data together
ward_data_cleaned <-
  bind_rows(ward_data_median_household_income, ward_data_avg_rent, ward_data_avg_owned_shelter_cost, ward_data_median_indv_income)
ward_data_cleaned

# Renaming data type values
ward_data_cleaned <-
  ward_data_cleaned |>
  mutate(
    data_type =
      case_match(
        data_type,
        "Average total income of households in 2020 ($)" ~ "Avg household income",
        "Average monthly shelter costs for rented dwellings ($)" ~ "Avg monthly rented shelter cost",
        "Average monthly shelter costs for owned dwellings ($)" ~ "Avg monthly owned shelter cost",
        "Median total income in 2020 among recipients ($)" ~ "Med indv income"
      )
  )
ward_data_cleaned


##### Save ward data ####
write_csv(
  x = ward_data_cleaned,
  file = "inputs/data/ward_data_cleaned.csv",
)