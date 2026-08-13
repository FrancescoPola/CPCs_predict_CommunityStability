Full simulation run used in the manuscript.

Folder structure:

- `code`
  - `run_simulations_complete.R`: script for running or re-running the full simulation workflow.

- `data`
  - `final_v0.7.json`: simulation design file for the full factorial run.
  - `experiment_table.RDS`: generated experiment table.
  - `community_measures.RDS`: derived community-level summary metrics.
  - `temperatures.db`: simulated temperature time series.

- `reports`
  - `analysis.qmd`: exploratory plots and model fits for this run.

Notes:

- The JSON file is the run definition for this simulation.
- The current contents of `data` include committed outputs that accompany the paper.
- The run script focuses on execution only; plotting and analysis live in `reports/analysis.qmd`.
