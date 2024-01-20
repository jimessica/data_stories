---
title: "scripts/00-simulate_data.R"
format: html
editor: visual
---

```{r}
#### Preamble ####
# Purpose: Simulates Fire Inspection Results
# Author: Jessica Im
# Date: 20 January 2024
# Contact: jessica.im@mail.utoronto.ca
# Pre-requisites: None
# Data:
## Fire Inspection Data: https://open.toronto.ca/dataset/highrise-residential-fire-inspection-results/
## Ward Data: https://open.toronto.ca/dataset/ward-profiles-25-ward-model/
  # Download "2023-WardProfiles-2011-2021-CensusData" data file

```

```{r}
#### Workspace setup ####
library(opendatatoronto)
library(dplyr)
library(tidyverse)
library(knitr)
library(janitor)
library(ggplot2)
```

```{r}
#### Simulate Fire Inspection Violations per Ward ####
#based on code from: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate and https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate-1

set.seed(250)

simulated_data <-
  tibble(
    # Use 1 through to 25 to represent each ward
    "Ward" = 1:25,
    # Randomly pick an option, with replacement, 25 times
    "Avg Num of Violations per Highrise" = sample(
      x = c("<10", "10 to 20", ">20"),
      size = 25,
      replace = TRUE
    ),
    "Total Num of Violations" =
      sample(100:500, 25, replace = TRUE),
    "Num of Highrises w/ Violations" =  
      sample(0:200, 25, replace = TRUE),
    "Highrises" =  
      sample(0:150, 25, replace = TRUE),
  )
simulated_data
```


```{r}
set.seed(250)

#### Simulate Household Income ####
simulate_data <-
  tibble(
    # Use 1 through to 25 to represent each ward
    "Ward" = 1:25,
    # Randomly pick an option, with replacement, 25 times
    "Median Income Household" =
      sample(70000:100000, 25, replace = TRUE),
    "Median Income Individual" =
      sample(30000:60000, 25, replace = TRUE),
  )
simulate_data
```



```{r}
set.seed(250)

#### Simulate Income x Fire Inspection Violations ####
simulated_data_x <-
  tibble(
    # Use 1 through to 25 to represent each ward
    "Ward" = 1:25,
    # Randomly pick an option, with replacement, 25 times
    "Avg Num of Violations per Highrise" = sample(
      x = c("<10", "10 to 20", ">20"),
      size = 25,
      replace = TRUE
    ),
    "Num of Highrises w/ Violations" =  
      sample(0:200, 25, replace = TRUE),
    "Highrises" =  
      sample(0:150, 25, replace = TRUE),
    "Median Income Household" =
      sample(70000:100000, 25, replace = TRUE),
    "Median Income Individual" =
      sample(30000:60000, 25, replace = TRUE),
  )

simulated_data_x
```


```{r}
#### Graph Household Income x Num of Highrises w/ Violations ####

# Create data
Ward = 1:25
Violations =  sample(0:200, 25, replace = TRUE)
Income = sample(70000:100000, 25, replace = TRUE)

data <-
  data.frame("Ward" = Ward, "Num of Highrises w/ Violations" = Violations, "Median Income Household" = Income)
data

# Create Scatterplot
# Based on code from: http://www.sthda.com/english/wiki/ggplot2-scatter-plots-quick-start-guide-r-software-and-data-visualization and https://ggplot2.tidyverse.org/reference/geom_text.html

ggplot(data, aes(x=Violations, y=Income)) +
  geom_point() + 
  geom_text(label=rownames(data), hjust = 0, nudge_x = 1) +
  geom_smooth(method=lm)

```


```{r}
#### Validating Data ####

# Test 1: 1 to 25 wards
# Based on: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html
simulate_data$Ward |> min() == 1
simulate_data$Ward |> max() == 25

# Test 2: Max 25 wards
# Based on code in: https://github.com/InessaDeAngelis/Toronto_Elections/blob/main/scripts/00-simulate_data.R

simulate_data |>
  group_by(Ward) |>
  count() |>
  filter(n > Ward) |>
  sum() == 0

# Test 3: There are between 0 to 150 Highrises
simulated_data$Highrises |> min() >= 0
simulated_data$Highrises |> max() <= 150

# Test 4: Median Income for Individuals is between 30,000 and 60,000
simulated_data_x$"Median Income Individual" |> max() >= 30000
simulated_data_x$"Median Income Individual" |> min() <= 60000
```

