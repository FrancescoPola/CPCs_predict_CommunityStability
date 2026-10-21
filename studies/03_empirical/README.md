# Study 3: empirical ciliate experiment

**Question.** Does variability in community performance predict variability in community biomass under fluctuating temperature regimes?

**Inputs.** `data/TPC_timeseries_df.csv` contains the monoculture thermal-performance experiment; `data/combined_timeseries_df.csv` contains the community time series.

**Run.** From the repository root, use `source("reproduce.R")`, or `quarto render studies/03_empirical/report.qmd`.

**Output.** Supplementary Information 3 in `outputs/reports/` and `outputs/submission/` when run through the root workflow. Typical runtime is under two minutes.

The first four acclimation days are excluded from the community analysis, and the three documented sampling-error observations are removed. CV(CP), population CV, and synchrony use the original exact-grid implementation retained in the empirical report and manuscript figure source.
