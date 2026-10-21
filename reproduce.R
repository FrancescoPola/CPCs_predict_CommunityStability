repo_root <- normalizePath(getwd(), winslash = "/", mustWork = TRUE)
if (!file.exists(file.path(repo_root, "CPCs_predict_CommunityStability.Rproj"))) {
  stop("Run reproduce.R from the repository root.", call. = FALSE)
}

arguments <- commandArgs(trailingOnly = TRUE)
check_only <- "--check" %in% arguments

required_inputs <- c(
  "studies/01_literature/data/literature_file.xls",
  "studies/03_empirical/data/TPC_timeseries_df.csv",
  "studies/03_empirical/data/combined_timeseries_df.csv",
  unlist(lapply(c("LV1", "LV2", "CR1", "CR2"), function(experiment) {
    file.path(
      "studies", "02_simulations", "experiments", experiment,
      c("experiment.yaml", "experiment_table.RDS", "population_summaries.RDS", "community_measures.RDS", "temperatures.db")
    )
  }))
)

missing_inputs <- required_inputs[!file.exists(file.path(repo_root, required_inputs))]
if (length(missing_inputs) > 0L) {
  stop("Missing required reproduction inputs:\n- ", paste(missing_inputs, collapse = "\n- "), call. = FALSE)
}

required_packages <- c(
  "conflicted", "dplyr", "forcats", "ggalluvial", "ggdist", "ggfortify",
  "ggplot2", "ggrepel", "knitr", "lavaan", "mgcv", "patchwork", "purrr",
  "ranger", "RColorBrewer", "readr", "readxl", "stringr", "tibble", "tidyr",
  "tidyverse", "viridis", "viridisLite"
)
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages) > 0L) {
  stop("Restore renv before reproducing; missing packages: ", paste(missing_packages, collapse = ", "), call. = FALSE)
}

quarto <- Sys.which("quarto")
if (!nzchar(quarto)) {
  stop("Quarto is required but was not found on PATH.", call. = FALSE)
}

message("Input and dependency checks passed.")
if (check_only) {
  quit(save = "no", status = 0L)
}

p_values_stale <- function(experiment) {
  experiment_dir <- file.path(repo_root, "studies", "02_simulations", "experiments", experiment)
  output <- file.path(experiment_dir, "p_values.RDS")
  inputs <- file.path(experiment_dir, c("experiment_table.RDS", "population_summaries.RDS"))
  !file.exists(output) || file.info(output)$mtime < max(file.info(inputs)$mtime)
}

if (any(vapply(c("LV1", "LV2"), p_values_stale, logical(1)))) {
  source(file.path(repo_root, "studies", "02_simulations", "calculate_p_values.R"), local = new.env(parent = globalenv()))
}

dir.create(file.path(repo_root, ".quarto"), showWarnings = FALSE)
dir.create(file.path(repo_root, ".quarto", "cache"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(repo_root, "outputs", "reports"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path(repo_root, "outputs", "submission"), recursive = TRUE, showWarnings = FALSE)
Sys.setenv(
  DENO_DIR = file.path(repo_root, ".quarto", "deno"),
  XDG_CACHE_HOME = file.path(repo_root, ".quarto", "cache")
)

reports <- data.frame(
  input = c(
    "studies/01_literature/report.qmd",
    "studies/02_simulations/report.qmd",
    "studies/03_empirical/report.qmd",
    "studies/04_theory/report.qmd",
    "manuscript/figures.qmd"
  ),
  output = c(
    "Supplementary_Info_1.html",
    "Supplementary_Info_2.html",
    "Supplementary_Info_3.html",
    "Supplementary_Info_4.html",
    "manuscript_figures.html"
  ),
  stringsAsFactors = FALSE
)

for (i in seq_len(nrow(reports))) {
  message("Rendering ", reports$input[[i]])
  report_dir <- file.path(repo_root, dirname(reports$input[[i]]))
  previous_working_directory <- getwd()
  setwd(report_dir)
  status <- system2(
    quarto,
    c(
      "render", basename(reports$input[[i]]), "--to", "html",
      "--output", reports$output[[i]]
    )
  )
  setwd(previous_working_directory)
  if (!identical(status, 0L)) {
    stop("Quarto failed while rendering ", reports$input[[i]], call. = FALSE)
  }
  rendered_in_place <- file.path(report_dir, reports$output[[i]])
  copied <- file.copy(
    rendered_in_place,
    file.path(repo_root, "outputs", "reports", reports$output[[i]]),
    overwrite = TRUE
  )
  if (!copied) {
    stop("Could not copy rendered output for ", reports$input[[i]], call. = FALSE)
  }
  unlink(rendered_in_place)
}

for (supplement in reports$output[seq_len(4L)]) {
  file.copy(
    file.path(repo_root, "outputs", "reports", supplement),
    file.path(repo_root, "outputs", "submission", supplement),
    overwrite = TRUE
  )
}

message("Reproduction complete. See outputs/reports/ and outputs/submission/.")
