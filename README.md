Community performance curves predict community stability despite interaction effects

This repository contains data, analysis, and supplementary materials for the manuscript titled "Community performance curves predict community stability despite interaction effects".

IMPORTANT: to run the simulations you need to install the newly developed package "community.simulator", available here: https://github.com/opetchey/community.simulator

Repository structure:

- simulation_study
  - organized by simulation run rather than by file type.
  - `final`: full simulation run with `code`, `data`, and `reports` subfolders.
  - `final_small`: reduced simulation run for reviewers with `code`, `data`, and `reports` subfolders.
  - `plot_effect_interactions`: subset of the simulation outputs used to plot the effects of interspecific interactions on species dynamics (Figure S4), also arranged into `code`, `data`, and `reports`.
    This is a curated slice of the broader simulation study used for figures that compare otherwise similar communities under different interaction strengths, so the direct effect of interactions on community dynamics can be visualized clearly.
  - each simulation-run folder contains its own `README.md` describing the purpose of that run and the files in it.

- empirical_study
  - code/empirical_example.R: code for reproducing the empirical example reported in the manuscript.
  - data: datasets required by the empirical analysis, including the derived summary table.

- literature_review
  - data/literature_file.xls: screening and extraction file for the literature review.

- reports
  - extended_results.qmd and extended_results.html: integrated reproducible report spanning the simulation study, empirical study, and literature review.

Simulation scripts:

- simulation_study/final/code/run_simulations_complete.R runs the full simulation study used in the manuscript.
- simulation_study/final_small/code/run_simulations_small.R runs a reduced version for quick checks and reviewer use.

Simulation design files:

- `simulation_study/final/data/final_v0.7.json` is the design file for the full manuscript simulation run.
- `simulation_study/final_small/data/final_small_v0.7.json` is the design file for the reduced reviewer-oriented run.
- `simulation_study/plot_effect_interactions/data/plot_effect_interactions_v0.7.json` is the design file for the interaction-effects subset.

The file `final_small_v0.7.json` is a reduced simulation design containing only two species-richness levels (2 and 4), a narrow range of thermal-optimum treatments (means 16-18 C and ranges 6-8 C), two levels of performance-curve breadth (means 6-8 and ranges 0-2), and two community and environmental replicates.

In contrast, `final_v0.7.json` encodes the full simulation design used in the manuscript: four richness levels (2, 4, 8, 16), a broader range of thermal-optimum treatments (means 16-24 C and ranges 6-14 C), an expanded set of performance-curve breadths (means 6-14 and ranges 0-10), and five community by five environmental replicates.

LICENSE.md: MIT license
