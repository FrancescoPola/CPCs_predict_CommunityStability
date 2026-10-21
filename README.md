# Community performance curves predict temporal stability despite interaction effects

Data, code, figures, and supplementary information for the manuscript **“Community performance curves predict temporal stability despite interaction effects.”**

## Quick start

The default route reuses the supplied simulation results; it does not rerun the simulations.

```r
install.packages("renv")
renv::restore()
source("reproduce.R")
```

This checks required inputs, refreshes stale analytical p-value intermediates, renders the four study reports and the manuscript figures, and writes the results to `outputs/reports/` and `outputs/submission/`. Use `Rscript reproduce.R --check` for a fast input and dependency check. The workflow was verified with R 4.5.1 and Quarto 1.9.37.

Full simulation reruns are deliberately separate because the four recorded runs took roughly five hours in total on the original system and replace supplied results only when explicitly requested. See `studies/02_simulations/README.md`.

## Repository map

```text
├── studies/
│   ├── 01_literature/      # literature review (SI 1)
│   ├── 02_simulations/     # four simulation experiments (SI 2)
│   ├── 03_empirical/       # ciliate experiment (SI 3)
│   └── 04_theory/          # analytical derivation (SI 4)
├── manuscript/figures.qmd  # all main-text figures
├── outputs/                # rendered reports and submission copies
├── archive/                # historical analyses and revision material
├── renv.lock               # pinned R environment
└── reproduce.R             # default reproduction entry point
```

## Manuscript and supplement provenance

| Material | Canonical source | Required inputs | Rendered output |
| --- | --- | --- | --- |
| SI 1: literature review | `studies/01_literature/report.qmd` | `studies/01_literature/data/` | `outputs/submission/Supplementary_Info_1.html` |
| SI 2: simulations | `studies/02_simulations/report.qmd` | `studies/02_simulations/experiments/` | `outputs/submission/Supplementary_Info_2.html` |
| SI 3: empirical study | `studies/03_empirical/report.qmd` | `studies/03_empirical/data/` | `outputs/submission/Supplementary_Info_3.html` |
| SI 4: theory | `studies/04_theory/report.qmd` | LV p-value intermediates | `outputs/submission/Supplementary_Info_4.html` |
| Main figures | `manuscript/figures.qmd` | inputs from studies 1–3 | `outputs/reports/manuscript_figures.html` |

The supplied compact simulation outputs remain versioned in the repository so the default reproduction route is self-contained. Superseded analyses, old result sets, and manuscript revision files are retained under `archive/` and are not read by active code.

## Environment

`renv.lock` records the report packages and pins `community.simulator` 0.9.0 to Git commit `dfab68123069b7191940b860f8a3eb9b0398d116`. Quarto 1.9.37 is the documented renderer; Quarto itself is not managed by `renv`.

## License

Released under the MIT license. See `LICENSE.md`.
