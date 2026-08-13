# Community performance curves predict community stability despite interaction effects

This repository contains the data, code, figures, and supplementary information for the manuscript **"Community performance curves predict community stability despite interaction effects"**.

The active repository is organised around three parts of the study:

1. a literature review;
2. four simulation experiments;
3. a purpose-designed empirical ciliate microcosm experiment.

The repository also contains a single Quarto file for reproducing the manuscript figures.

## Repository Structure

```text
CPCs_predict_CommunityStability/
├── literature_review/
├── manuscript figure/
├── new_empirical_study/
├── publication_experiments/
├── old/
├── Supplementary_Info_1.html
├── Supplementary_Info_2.html
└── Supplementary_Info_3.html
```

## Main Folders

### `literature_review/`

Contains the literature-review data and supplementary report.

- `data/literature_file.xls`: screening and extraction table for the literature review.
- `literature_review_supplement.qmd`: Quarto source for the literature-review supplement.
- `literature_review_supplement.html`: rendered HTML supplement.

Render with:

```bash
cd literature_review
quarto render literature_review_supplement.qmd
```

### `publication_experiments/`

Contains the simulation study supplement and the publication-ready simulation outputs.

- `CPC_supplementary_information_simulation_clean.qmd`: Quarto source for the simulation supplement.
- `CPC_supplementary_information_simulation_clean.html`: rendered simulation supplement.
- `run_all.R`: script for rerunning the four publication simulation experiments.
- `README.md`: detailed simulation-folder README.
- `data/`: simulation inputs and outputs used by the report.

The active simulation runs are:

| Folder | Framework | Description |
| --- | --- | --- |
| `data/LV1` | Lotka-Volterra | Asymmetric uniform interaction-strength gradient |
| `data/LV2` | Lotka-Volterra | Symmetric log-normal interaction-strength gradient |
| `data/CR1` | Consumer-resource | Deterministic shared-resource gradient |
| `data/CR2` | Consumer-resource | Stochastic shared-resource gradient |

Each simulation folder contains the corresponding YAML specification, `community_measures.RDS`, `experiment_table.RDS`, `population_summaries.RDS`, `simulation_summaries.RDS`, `temperatures.db`, and run logs.


To rerun the simulation experiments, first install the R package `community.simulator`


### `new_empirical_study/`

Contains the empirical ciliate microcosm analysis and report.

- `data/combined_timeseries_df.csv`: community experiment time-series data.
- `data/TPC_timeseries_df.csv`: monoculture thermal-performance experiment data.
- `Combined_TPC_CPC_Report.qmd`: Quarto source for the empirical supplement.
- `Combined_TPC_CPC_Report.html`: rendered empirical supplement.


### `manuscript figure/`

Contains the reproducible figure file for the main manuscript.

- `manuscript_figures.qmd`: Quarto source for the manuscript figures.
- `manuscript_figures.html`: rendered figure document.


This file reproduces the conceptual figures, literature-review figure, simulation figure, empirical predictor figure, and empirical SEM figure used for the manuscript.

### `old/`

Archive of earlier analyses, reports, and exploratory folders. These files are retained for project history but are not the active source for the current manuscript figures or supplements.

## Top-Level Supplement Files

The root folder also contains rendered copies of the supplementary information:

- `Supplementary_Info_1.html`: literature-review supplement.
- `Supplementary_Info_2.html`: simulation supplement.
- `Supplementary_Info_3.html`: empirical-study supplement.

The source files for these supplements are in the folders described above.


## Recommended Use

For reproducing the current manuscript materials, use the active folders in this order:

1. Render `literature_review/literature_review_supplement.qmd`.
2. Render `publication_experiments/CPC_supplementary_information_simulation_clean.qmd`.
3. Render `new_empirical_study/Combined_TPC_CPC_Report.qmd`.
4. Render `manuscript figure/manuscript_figures.qmd`.

The Quarto documents read the data from the current `data/` folders and should run without using the archived `old/` directory.

## License

This repository is released under the MIT license. See `LICENSE.md`.
