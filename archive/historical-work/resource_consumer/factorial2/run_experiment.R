# Run this file interactively from RStudio.
# Edit these two values before sourcing if needed.
overwrite_outputs <- TRUE
render_report <- TRUE
report_filename <- "factorial_report.qmd"
recalculate_community_measures_only <- FALSE
reinstall_community_simulator_from_github <- FALSE
community_simulator_github_repo <- "opetchey/community.simulator"

command_args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", command_args, value = TRUE)

if (length(file_arg) > 0) {
  script_dir <- dirname(normalizePath(sub("^--file=", "", file_arg[[1]])))
} else if (requireNamespace("rstudioapi", quietly = TRUE) &&
    rstudioapi::isAvailable()) {
  active_path <- rstudioapi::getActiveDocumentContext()$path
  if (nzchar(active_path)) {
    script_dir <- dirname(normalizePath(active_path))
  } else {
    script_dir <- normalizePath(".")
  }
} else {
  # Fallback for non-RStudio interactive use: set the working directory to this
  # folder before sourcing the file.
  script_dir <- normalizePath(".")
}

experiment_folder_location <- dirname(script_dir)
experiment_name <- basename(script_dir)
experiment_design_filename <- "factorial2.json"

community_simulator_needs_refresh <- TRUE
if (requireNamespace("community.simulator", quietly = TRUE)) {
  community_simulator_needs_refresh <- !"confirm_run" %in%
    names(formals(community.simulator::run_experiment))
}

if (reinstall_community_simulator_from_github ||
    !requireNamespace("community.simulator", quietly = TRUE) ||
    community_simulator_needs_refresh) {
  if (!requireNamespace("remotes", quietly = TRUE)) {
    install.packages("remotes")
  }
  if (community_simulator_needs_refresh) {
    message("Refreshing community.simulator from GitHub because the installed copy is older than this experiment requires.")
  }
  remotes::install_github(community_simulator_github_repo, upgrade = "never")
}

library(community.simulator)

if (recalculate_community_measures_only) {
  message("Recalculating community measures only")
  get_community_measures(
    experiment_folder = paste0(script_dir, .Platform$file.sep),
    experiment_design_filename = experiment_design_filename,
    overwrite = TRUE,
    verbose = TRUE
  )
} else {
  run_experiment(
    experiment_folder_location = experiment_folder_location,
    experiment_name = experiment_name,
    experiment_design_filename = experiment_design_filename,
    overwrite = overwrite_outputs,
    verbose = TRUE
  )
}

if (render_report) {
  report_path <- file.path(script_dir, report_filename)
  if (!file.exists(report_path)) {
    message("Skipping report render because ", report_filename, " was not found in ", script_dir)
  } else {
    quarto_bin <- Sys.which("quarto")
    if (quarto_bin == "") {
      stop("Could not find the `quarto` executable on PATH, so the report was not rendered.", call. = FALSE)
    }

    old_wd <- getwd()
    on.exit(setwd(old_wd), add = TRUE)
    setwd(script_dir)

    message("Rendering ", report_filename)
    render_status <- system2(quarto_bin, c("render", report_filename))
    if (!identical(render_status, 0L)) {
      stop("Report rendering failed with exit status ", render_status, ".", call. = FALSE)
    }
  }
}
