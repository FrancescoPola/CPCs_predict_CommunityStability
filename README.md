# Community performance curves predict temporal stability despite interaction effects

This repository contains the data, code, figures, and supplementary information for the manuscript **“Community performance curves predict temporal stability despite interaction effects.”**

The active analysis has four components:

1. a literature review;
2. four simulation experiments;
3. a purpose-designed ciliate microcosm experiment; and
4. an analytical Lotka–Volterra derivation.

The `old/` directory is an archive and is not used by the current analyses.

## Repository structure

```text
CPCs_predict_CommunityStability/
├── literature_review/             # Supplementary Information 1
├── publication_experiments/       # Supplementary Information 2
├── new_empirical_study/           # Supplementary Information 3
├── Supplementary_Info_4.qmd       # Supplementary Information 4 source
├── manuscript figure/             # Main-text figure source
├── old/                           # Archived analyses; not used
├── Supplementary_Info_1.html      # Submission copy of SI1
├── Supplementary_Info_2.html      # Submission copy of SI2
├── Supplementary_Info_3.html      # Submission copy of SI3
└── Supplementary_Info_4.html      # Submission copy of SI4
```

## Canonical sources and outputs

| Material | Canonical source | Canonical rendered output |
| --- | --- | --- |
| Supplementary Information 1: literature review | `literature_review/literature_review_supplement.qmd` | `literature_review/literature_review_supplement.html` |
| Supplementary Information 2: simulation studies | `publication_experiments/CPC_supplementary_information_simulation_clean.qmd` | `publication_experiments/CPC_supplementary_information_simulation_clean.html` |
| Supplementary Information 3: empirical study | `new_empirical_study/Combined_TPC_CPC_Report.qmd` | `new_empirical_study/Combined_TPC_CPC_Report.html` |
| Supplementary Information 4: analytical derivation | `Supplementary_Info_4.qmd` | `Supplementary_Info_4.html` |
| Main-text figures | `manuscript figure/manuscript_figures.qmd` | `manuscript figure/manuscript_figures.html` |

The four top-level `Supplementary_Info_*.html` files are submission copies. They should be refreshed from the canonical rendered outputs above before submission.

## Data and analyses

### Literature review

`literature_review/data/literature_file.xls` contains the screening and extraction table. The Quarto report reads this file and reproduces the literature-review figure and summary.

### Simulation experiments

`publication_experiments/data/` contains four active experiments:

| Folder | Framework | Treatment |
| --- | --- | --- |
| `LV1` | Continuous-time Lotka–Volterra | Asymmetric uniform competition gradient |
| `LV2` | Continuous-time Lotka–Volterra | Symmetric log-normal competition gradient |
| `CR1` | Continuous-time consumer–resource | Deterministic private-to-shared resource-use gradient |
| `CR2` | Continuous-time consumer–resource | Stochastic beta-distributed private-to-shared resource-use gradient |

Each experiment folder contains its active specification (`experiment.yaml`), compact simulation outputs, temperature database, and run log. Each run contains 7,290 valid simulations.

Across all four experiments, simulations used a 200-time-unit burn-in followed by 2,000 time units of environmental forcing. Forced temperatures had a mean of 20 °C, a standard deviation of 4 °C, and 1/*f* temporal autocorrelation with exponent γ = 0.8. The Lotka–Volterra experiments used continuous immigration of 0.1 biomass units per species per unit time.

See `publication_experiments/README.md` for simulation-specific notes and `publication_experiments/run_all.R` for the batch runner.

### Empirical experiment

`new_empirical_study/data/` contains:

- `combined_timeseries_df.csv`: community experiment time series;
- `TPC_timeseries_df.csv`: monoculture thermal-performance experiment data.

`Combined_TPC_CPC_Report.qmd` reproduces the empirical analyses and supplementary figures.

### Analytical derivation

`Supplementary_Info_4.qmd` develops the continuous-time Lotka–Volterra link between community-performance variability and total-abundance variability and evaluates its assumptions against the simulations.

### Main-text figures

`manuscript figure/manuscript_figures.qmd` reproduces the conceptual, literature-review, simulation, empirical-predictor, and structural-equation-model figures used in the manuscript.

## Rendering the reports

The analyses require R, Quarto, and the R packages loaded at the start of each `.qmd` file. Simulation reruns additionally require the `community.simulator` package.

From the repository root, render the reports in this order:

```bash
quarto render literature_review/literature_review_supplement.qmd
quarto render publication_experiments/CPC_supplementary_information_simulation_clean.qmd
quarto render new_empirical_study/Combined_TPC_CPC_Report.qmd
quarto render Supplementary_Info_4.qmd
quarto render "manuscript figure/manuscript_figures.qmd"
```

The active reports read only the current data directories; they do not depend on `old/`. After rerunning either Lotka–Volterra experiment, run `source("publication_experiments/calculate_p_values.R")` from R before rendering Supplementary Information 4.

## License

This repository is released under the MIT license. See `LICENSE.md`.
