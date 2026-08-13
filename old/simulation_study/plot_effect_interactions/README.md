Subset of simulation outputs used to visualize interaction effects on species dynamics.

This subset is a small, purpose-built slice of the broader simulation study. It
is intended for figures that show how changing interaction strength affects the
temperature-response relationships and abundance dynamics of otherwise
comparable communities. In the manuscript workflow, it is used to compare cases
where most settings are held constant while interaction strength differs, making
it easier to inspect the direct effect of interactions on community dynamics.

Folder structure:

- `code`
  - `run_simulation_plot_effect_interactions.R`: script for recreating the standard workflow outputs and derivative files used by the interaction-effects subset.

- `data`
  - `plot_effect_interactions_v0.7.json`: simulation design file for this subset.
  - `experiment_table.RDS`: generated experiment table.
  - `community_measures.RDS`: community summary metrics.
  - `temperatures.db`: simulated temperature time series.
  - `dynamics.db`: simulated species dynamics.
  - `temporal_derivs.db`: temporal derivative outputs.
  - `arbitrary_derivs.db`: arbitrary derivative outputs.
  - `delta_igr.db`: delta intrinsic-growth-rate outputs.

- `reports`
  - `analysis.qmd`: exploratory report for the interaction-effects subset, including summary plots and the paired-case interaction comparison used in the manuscript workflow.

Notes:

- This folder supports the interaction-effect visualizations referenced in the manuscript supplementary material.
- The JSON file is stored in `data` with the outputs it defines.
