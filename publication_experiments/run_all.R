# Install the current Codex-branch version before running, if needed.
install.packages("remotes")
remotes::install_github(
  "opetchey/community.simulator@codex/yaml-spec-rewrite",
  build_vignettes = TRUE,
  dependencies = TRUE,
  upgrade = "never"
)

library(community.simulator)

overwrite_output <- TRUE
preflight_check <- FALSE
verbose_output <- TRUE

experiment_folder_location <- normalizePath(
  path.expand("data"),
  winslash = "/",
  mustWork = TRUE
)

experiments <- data.frame(
  experiment_name = c("LV1", "LV2", "CR1", "CR2"),
  experiment_design_filename = c(
    "canonical_01_lv_factorial_publication.yaml",
    "canonical_02_lv_factorial_publication.yaml",
    "canonical_01_cr_factorial_publication.yaml",
    "canonical_02_cr_factorial_publication.yaml"
  ),
  stringsAsFactors = FALSE
)

# Run all experiments.
for (i in seq_len(nrow(experiments))) {
  run_experiment(
    experiment_folder_location = experiment_folder_location,
    experiment_name = experiments$experiment_name[[i]],
    experiment_design_filename = experiments$experiment_design_filename[[i]],
    overwrite = overwrite_output,
    confirm_run = preflight_check,
    verbose = verbose_output
  )
}

# Run one experiment manually by changing `experiment_to_run` and changing this
# guard to TRUE.
if (FALSE) {
  experiment_to_run <- "LV1"
  selected <- experiments[experiments$experiment_name == experiment_to_run, ]

  if (nrow(selected) == 1) {
    run_experiment(
      experiment_folder_location = experiment_folder_location,
      experiment_name = selected$experiment_name[[1]],
      experiment_design_filename = selected$experiment_design_filename[[1]],
      overwrite = overwrite_output,
      confirm_run = preflight_check,
      verbose = verbose_output
    )
  }
}
