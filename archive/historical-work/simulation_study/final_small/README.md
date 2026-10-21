Reduced simulation run for reviewer checks and quick testing.

Folder structure:

- `code`
  - `run_simulations_small.R`: script for running or inspecting the reduced simulation workflow.

- `data`
  - `final_small_v0.7.json`: simulation design file for the reduced run.
  - `experiment_table.RDS`: generated experiment table.
  - `community_measures.RDS`: derived community-level summary metrics.
  - `temperatures.db`: simulated temperature time series.
  - `dynamics.db`: simulated species dynamics.
 
- `reports`
  - `analysis.qmd`: exploratory plots and model fits for this run.

Notes:

- This run is a smaller version of the manuscript simulation study intended for reproducibility checks, debugging, and reviewer-oriented execution.
- The JSON file is stored in `data` with the outputs it defines.
- The run script focuses on execution only; plotting and analysis live in `reports/analysis.qmd`.
