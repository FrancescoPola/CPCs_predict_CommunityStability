rm(list = ls())

library(tidyverse)
library(zoo)
library(readxl)
library(here)
library(kableExtra)
library(patchwork)
library(primer)
library(DBI)
library(RSQLite)
library(dplyr)
library(dirmult)
library(jsonlite)
library(MESS)
library(broom)
library(tidyr)
library(purrr)
library(gratia)
library(community.simulator)

## Use this to load the package with any changes made to functions
devtools::load_all()

## Run configuration
experiment_folder_location <- here("simulation_study", "final")
experiment_name <- "data"
experiment_design_filename <- "final_v0.7.json"

## Create folder for experiment, if it does not already exist
experiment_folder <- create_experiment_folder(experiment_folder_location, experiment_name)

## Create experiment table
create_experiment_table(experiment_folder, experiment_design_filename)

# alpha_ij_sd == 0 but alpha_ij_mean > 0 because we don't want cases where all
# interactions are non-zero and identical
expt <- readRDS(file.path(experiment_folder, "experiment_table.RDS"))
expt <- expt %>%
  filter(
    !(alpha_ij_sd > 0 & alpha_ij_mean == 0),
    !(alpha_ij_sd == 0 & alpha_ij_mean > 0)
  )
saveRDS(expt, file.path(experiment_folder, "experiment_table.RDS"))

## Create environments
create_environments(experiment_folder, experiment_design_filename)

## Simulate dynamics
simulate_dynamics(experiment_folder, experiment_design_filename)

## Get the community measures
get_community_measures(experiment_folder, experiment_design_filename)

message("Simulation workflow complete.")
message("For exploratory plots and model fits, see simulation_study/final/reports/analysis.qmd")
