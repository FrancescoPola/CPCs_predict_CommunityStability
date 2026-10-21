# Study 2: simulation experiments

**Question.** Does actual community-performance variability predict temporal community variability across Lotka–Volterra and consumer–resource models and interaction treatments?

## Supplied-results route (default)

`experiments/{LV1,LV2,CR1,CR2}/` contains the active experiment specification, compact outputs, temperature database, and run log for each 7,290-case experiment. These supplied files are the reproduction inputs; no simulation rerun is needed.

From the repository root, use `source("reproduce.R")`, or render only this report with:

```bash
quarto render studies/02_simulations/report.qmd
```

The report normally renders in a few minutes. `calculate_p_values.R` regenerates the LV analytical p-value files when the root workflow finds they are missing or older than their inputs.

## Full-rerun route (deliberate and separate)

The simulator is pinned in `renv.lock` to `community.simulator` 0.9.0, Git commit `dfab68123069b7191940b860f8a3eb9b0398d116`. The recorded completed runs took about 54 minutes for LV2 and 1.4 hours for each CR experiment; allow roughly five hours for all four, depending on hardware. LV1's supplied log is incomplete, although its 7,290 compact results are present.

Existing results are protected by default:

```bash
Rscript studies/02_simulations/run_simulations.R --run
```

That command refuses to overwrite existing outputs. To deliberately replace them, use:

```bash
Rscript studies/02_simulations/run_simulations.R --run --overwrite
```

After a rerun, execute `Rscript studies/02_simulations/calculate_p_values.R` before rendering SI 4. Simulation summaries exclude burn-in and use the specifications recorded in each `experiment.yaml`; detailed model settings are documented in the report.
