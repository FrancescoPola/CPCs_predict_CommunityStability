# Publication simulation experiments

This directory contains the four simulation experiments used in the manuscript and the report that analyses their compact outputs. The active experiments use the YAML workflow in `community.simulator`.

| Folder | Model | Treatment | Cases |
| --- | --- | --- | ---: |
| `data/LV1` | Continuous-time Lotka–Volterra | Asymmetric uniform competition gradient | 7,290 |
| `data/LV2` | Continuous-time Lotka–Volterra | Symmetric log-normal competition gradient | 7,290 |
| `data/CR1` | Continuous-time consumer–resource | Deterministic private-to-shared resource-use gradient | 7,290 |
| `data/CR2` | Continuous-time consumer–resource | Stochastic beta-distributed private-to-shared resource-use gradient | 7,290 |

| Folder | YAML file | Purpose | Main treatment mode | Expected cases |
| --- | --- | --- | --- | ---: |
| `data/LV1` | `experiment.yaml` | Larger continuous-time LV publication experiment, compact summaries only | Uniform asymmetric competition gradient | 7290 |
| `data/LV2` | `experiment.yaml` | Larger continuous-time LV publication experiment, compact summaries only | Log-normal symmetric competition gradient | 7290 |
| `data/CR1` | `experiment.yaml` | Larger consumer-resource publication experiment, compact summaries only | Deterministic private-resource-use gradient | 7290 |
| `data/CR2` | `experiment.yaml` | Larger consumer-resource publication experiment, compact summaries only | Stochastic beta private-resource-use gradient | 7290 |

Each active experiment directory contains its specification in `experiment.yaml`, compact result files, a temperature database, and a newline-delimited JSON run log. Earlier outputs are retained only under `data/old/` and are not read by the current report.

## Current simulation design

All four experiments use a 200-time-unit burn-in followed by 2,000 time units of environmental forcing. Temperature has a mean of 20 °C, a standard deviation of 4 °C, and 1/*f* temporal autocorrelation with exponent γ = 0.8. The ordinary differential equations are integrated with `lsoda`, relative tolerance `1e-2`, absolute tolerance `1e-4`, and a maximum step of one time unit.

The Lotka–Volterra experiments use continuous immigration of 0.1 biomass units per species per unit time. Their thermal-breadth means are 6, 10, and 14. The consumer–resource experiments use consumer immigration of 0.060511 biomass units per species per unit time and uptake-breadth means of 3, 6, and 9.

## Rerunning the experiments

Install a version of `community.simulator` that supports the active YAML schema, open this directory in R, and run:

```r
source("run_all.R")
```

`run_all.R` processes `data/LV1/experiment.yaml`, `data/LV2/experiment.yaml`, `data/CR1/experiment.yaml`, and `data/CR2/experiment.yaml`. It overwrites existing outputs by default. Change `overwrite_output` to `FALSE` if existing results must be preserved.

The experiments save compact summaries rather than full `dynamics.db` or `resources.db` files. Full reruns can take substantial time.

The supplied `data/LV1/experiment_log.txt` ends when the community-measures step starts and does not contain a workflow-completion event. The active LV1 output files are present and contain all 7,290 cases, but the missing historical log events cannot be reconstructed reliably. A future full LV1 rerun will replace this partial provenance log.

## Analytical p values

Supplementary Information 4 uses the realised interaction matrices and species mean abundances from the LV experiments to calculate the analytical weight `p`. Regenerate these files after rerunning either LV experiment:

```r
source("calculate_p_values.R")
```

This creates `data/LV1/p_values.RDS` and `data/LV2/p_values.RDS` from the active outputs.

## Rendering the simulation supplement

From the repository root, run:

```bash
quarto render publication_experiments/CPC_supplementary_information_simulation_clean.qmd
```

The resulting `CPC_supplementary_information_simulation_clean.html` is the canonical Supplementary Information 2 file.
