library(community.simulator)

find_repo_root <- function(start = getwd()) {
  current <- normalizePath(start, winslash = "/", mustWork = TRUE)
  repeat {
    if (file.exists(file.path(current, "CPCs_predict_CommunityStability.Rproj"))) {
      return(current)
    }
    parent <- dirname(current)
    if (identical(parent, current)) {
      stop("Could not locate the CPCs_predict_CommunityStability repository root.")
    }
    current <- parent
  }
}

overwrite_output <- TRUE
preflight_check <- FALSE
verbose_output <- TRUE

experiment_folder_location <- normalizePath(
  file.path(find_repo_root(), "publication_experiments", "data"),
  winslash = "/",
  mustWork = TRUE
)

experiments <- data.frame(
  experiment_name = c("LV1", "LV2", "CR1", "CR2"),
  experiment_design_filename = rep("experiment.yaml", 4),
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
