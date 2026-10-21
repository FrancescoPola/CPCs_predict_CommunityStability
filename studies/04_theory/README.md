# Study 4: analytical theory

**Question.** Under which interaction structures should community-performance variability predict temporal variability in total community abundance?

**Inputs.** The derivation is self-contained; its simulation comparison reads `p_values.RDS` from the LV1 and LV2 experiment directories. The root workflow regenerates these intermediates when stale.

**Run.** From the repository root, use `source("reproduce.R")`, or `quarto render studies/04_theory/report.qmd` after running `Rscript studies/02_simulations/calculate_p_values.R`.

**Output.** Supplementary Information 4 in `outputs/reports/` and `outputs/submission/`. Typical runtime is under one minute. The mathematical assumptions and simulation exclusions are stated in the report.
