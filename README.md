Community performance curves predict community stability despite interaction effects

This repository contains data, analysis, and supplementary materials for the manuscript titled "Community performance curves predict community stability despite interaction effects".

IMPORTANT: to run the simulations you need to install the newly developed package "community.simulator", available here: https://github.com/opetchey/community.simulator

Contents - there 3 folders:

Code: folder contains 3 R scripts
  - empirical example.r: code for reproducing the results  relative to the empirical example reported in the manuscript.
  - run_simulations_complete.R: code for running the complete simulations used in the part called "simulation study" in the manuscript.
  - run_simulations_small.R: code for running a reduced version of the simulations, for reviewers. The code is the same. What changes is the .JSON file that creates the simulations. Running the complete code and generate the related species dynamics is computationally very heavy. The file final_small_v0.7.json is a reduced version of the simulation design, containing only two species‑richness levels (2 and 4), a narrow range of thermal‑optimum treatments (means 16–18 °C and ranges 6–8 °C), and only two levels of performance‑curve breadth (means 6–8 and ranges 0–2). It also uses just two community replicates and two environmental replicates, making it suitable for quick test runs or debugging. 
In contrast, final_v0.7.json encodes the full simulation design used in the CPC manuscript: four richness levels (2, 4, 8, 16), a broader range of thermal‑optimum treatments (means 16–24 °C and ranges 6–14 °C), an expanded set of performance‑curve breadths (means 6–14 and ranges 0–10), and five community × five environmental replicates. This version produces the complete factorial dataset used in the main analyses.
  

Data: Contains 3 other folders:
- empirical study: datasets needed for running the code called "empirical example.r" in the folder "code", and reproduce the results relative to the empirical example presented in the manuscript.

- review: contains the .xls file with the results of the literature review which reports which studies have been included and why, and why the other have been excluded.

-simulation study: contains the folder called "experiments" with another 3 subfolders:

 . final: datasets and files to reproduce the full simulation study.
 . final small: reduced version of the simulation study for reviewers.
 . plot_effect_interactions: subset of "final" used to plot the effects of interspecific interactions on species dynamics (figure S4)

reports: folder containing the .html and .qmd files containing all the code to completely reproduce the analyses and figures presented in the manuscript, plus some additional figures.




LICESNSE.md : MIT license