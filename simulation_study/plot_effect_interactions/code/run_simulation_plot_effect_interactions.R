rm(list = ls())

library(here)
library(community.simulator)

## Run configuration
experiment_folder_location <- here("simulation_study", "plot_effect_interactions")
experiment_name <- "data"
experiment_design_filename <- "plot_effect_interactions_v0.7.json"

experiment_folder <- create_experiment_folder(
  experiment_folder_location = experiment_folder_location,
  experiment_name = experiment_name,
  verbose = TRUE
)

outputs <- list(
  experiment_folder = experiment_folder,
  experiment_table = file.path(experiment_folder, "experiment_table.RDS"),
  temperatures_db = file.path(experiment_folder, "temperatures.db"),
  dynamics_db = file.path(experiment_folder, "dynamics.db"),
  community_measures = file.path(experiment_folder, "community_measures.RDS")
)

required_outputs <- c(
  outputs$experiment_table,
  outputs$temperatures_db,
  outputs$dynamics_db,
  outputs$community_measures
)

## Reuse committed outputs when they already exist; otherwise run the standard
## workflow provided by the installed package.
if (!all(file.exists(required_outputs))) {
  outputs <- suppressWarnings(
    suppressMessages(
      run_experiment(
        experiment_folder_location = experiment_folder_location,
        experiment_name = experiment_name,
        experiment_design_filename = experiment_design_filename,
        overwrite = FALSE,
        verbose = TRUE
      )
    )
  )
}

## Additional derivative outputs used by the interaction-effects figure.
temporal_derivs_db <- file.path(experiment_folder, "temporal_derivs.db")
arbitrary_derivs_db <- file.path(experiment_folder, "arbitrary_derivs.db")
delta_igr_db <- file.path(experiment_folder, "delta_igr.db")

if (!file.exists(temporal_derivs_db)) {
  suppressMessages(
    get_temporal_derivatives(
      experiment_folder,
      experiment_design_filename,
      every_t = 10
    )
  )
}

if (!file.exists(arbitrary_derivs_db)) {
  suppressMessages(
    get_arbitrary_derivatives(experiment_folder, experiment_design_filename)
  )
}

if (!file.exists(delta_igr_db)) {
  get_delta_igr(experiment_folder, experiment_design_filename, every_t = 1)
}

message("Interaction-effects subset workflow complete.")
message("Core outputs are in simulation_study/plot_effect_interactions/data")
message("Note: this script recreates the standard workflow and derivative files.")
message("Files such as imbalance.db or community_measures_new.RDS are preserved if")
message("already present, but no helper was found in the installed package to")
message("rebuild them directly.")
