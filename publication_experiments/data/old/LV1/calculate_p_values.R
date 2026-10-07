suppressPackageStartupMessages({
  library(dplyr)
  library(tibble)
})

experiment_dir <- getwd()
experiment_name <- basename(experiment_dir)

experiment_table <- readRDS(file.path(experiment_dir, "experiment_table.RDS")) |> as_tibble()
population_summaries <- readRDS(file.path(experiment_dir, "population_summaries.RDS")) |> as_tibble()

population_moments <- population_summaries |>
  group_by(.data$case_id) |>
  summarise(
    species_mean_abundances = list(as.numeric(.data$mean_ab_pop)),
    .groups = "drop"
  )

calculate_p <- function(community, species_mean_abundances) {
  alpha <- as.matrix(community$alpha_ij)
  richness <- length(species_mean_abundances)
  off_diagonal <- alpha[row(alpha) != col(alpha)]
  self_interaction <- mean(diag(alpha), na.rm = TRUE)
  mean_interaction <- mean(off_diagonal, na.rm = TRUE)
  interaction_variance <- stats::var(off_diagonal, na.rm = TRUE)
  if (!is.finite(interaction_variance)) interaction_variance <- 0
  c_value <- self_interaction + (richness - 1) * mean_interaction
  average_component <- c_value^2 * sum(species_mean_abundances, na.rm = TRUE)^2
  heterogeneity_component <- richness * interaction_variance * sum(species_mean_abundances^2, na.rm = TRUE)
  denominator <- average_component + heterogeneity_component

  tibble(
    p = ifelse(denominator > 0, average_component / denominator, NA_real_),
    self_interaction = self_interaction,
    mean_interaction = mean_interaction,
    interaction_variance = interaction_variance,
    c_value = c_value,
    average_component = average_component,
    heterogeneity_component = heterogeneity_component
  )
}

diagnostic_inputs <- experiment_table |>
  select(all_of(c(
    "case_id", "treatment_id", "treatment_label", "interaction_treatment_label",
    "richness", "community_id", "treatment_values", "community_object"
  ))) |>
  left_join(population_moments, by = "case_id")

p_values <- lapply(seq_len(nrow(diagnostic_inputs)), function(i) {
  calculate_p(
    diagnostic_inputs$community_object[[i]],
    diagnostic_inputs$species_mean_abundances[[i]]
  )
}) |>
  bind_rows() |>
  bind_cols(diagnostic_inputs |> select(-all_of(c("community_object", "species_mean_abundances")))) |>
  relocate(all_of(c(
    "case_id", "treatment_id", "treatment_label", "interaction_treatment_label",
    "richness", "community_id"
  ))) |>
  mutate(experiment = experiment_name, .before = 1)

saveRDS(p_values, file.path(experiment_dir, "p_values.RDS"))
message("Saved ", nrow(p_values), " p values to ", file.path(experiment_dir, "p_values.RDS"))
