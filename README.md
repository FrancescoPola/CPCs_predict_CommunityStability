# Community performance curves predict community stability despite interaction effects

This repository contains data, analysis, and supplementary materials for the manuscript titled "Community performance curves predict community stability despite interaction effects".

IMPORTANT: to run the simulations you need to install the newly developed package "community.simulator", available here: https://github.com/opetchey/community.simulator

Contents - there 3 folders:

Data: Contains the datasets needed to reproduce the analysis, including a .xls file with the results of the literature review which reports which studies have been included and why, and why the other have been excluded.

Reports: folder containing the .html and .qmd files contanining all the code to completely reproduce the analyses and figures presented in the manuscript, plus some additional figures.

experiments: folder contains 3 sub-folders
  - final: results of the simulations obtained with the code contained in the .R documented called "run_simulations". It is composed of several datasets that are needed to run the files in "Reports".
  - plot_effect_interactions: subset of "final" used to plot the effects of interspecific interactions on species dynamics (figure S4)

run_simulations.R: code and .JSON file needed to reproduce the simulations.
empirical_example.r: code that analyses the empirical example and prepare dataset for Fig.4 of the manuscript
