# Proposal: Improve Repository Organisation and Reproducibility

## Purpose

Make it straightforward for a reader to reproduce the manuscript figures and supplementary reports, understand where each result comes from, and distinguish current analyses from historical work. This proposal concerns organisation and workflow; it does not propose changes to the experimental designs.

## Suggested Structure

Organise the repository around the four studies, using consistent names and a shallow directory structure:

```text
CPCs_predict_CommunityStability/
|-- README.md
|-- CPCs_predict_CommunityStability.Rproj
|-- renv.lock
|-- reproduce.R
|-- studies/
|   |-- 01_literature/
|   |   |-- README.md
|   |   |-- data/
|   |   `-- report.qmd
|   |-- 02_simulations/
|   |   |-- README.md
|   |   |-- experiments/
|   |   |   |-- LV1/
|   |   |   |   |-- experiment.yaml
|   |   |   |   |-- results/
|   |   |   |   `-- experiment_log.txt
|   |   |   |-- LV2/   # Same structure as LV1
|   |   |   |-- CR1/   # Same structure as LV1
|   |   |   `-- CR2/   # Same structure as LV1
|   |   |-- run_simulations.R
|   |   |-- calculate_p_values.R
|   |   `-- report.qmd
|   |-- 03_empirical/
|   |   |-- README.md
|   |   |-- data/
|   |   |-- R/
|   |   `-- report.qmd
|   `-- 04_theory/
|       |-- README.md
|       `-- report.qmd
|-- manuscript/
|   `-- figures.qmd
|-- R/
|   `-- shared_helpers.R
|-- outputs/          # Generated reports and figures
`-- archive/          # Historical work
```

## Recommended Workflow Changes

1. **Provide two explicit reproduction routes.** Reproducing analyses from supplied simulation results should be the default. Rerunning simulations should require a separate, deliberate command, with runtime estimates and protection against unintended overwriting.

2. **Pin the software environment.** Include an `renv.lock` file, record the exact `community.simulator` release or commit, and document the required Quarto version. Ensure that the simulator version supports every field used in the experiment specifications.

3. **Use one authoritative implementation of each calculation.** Move duplicated empirical calculations into shared R functions used by both the supplementary report and manuscript figures. This ensures that corrections propagate consistently.

4. **Make dependencies automatic.** A root-level `reproduce.R` should check inputs, regenerate required intermediate results such as p values, and render reports and figures in the correct order. Document whether each intermediate is regenerated or reused and how stale results are detected.

5. **Separate supplied results from generated intermediates.** Identify which simulation outputs are essential reproduction inputs. Distribute these through Git or a versioned data archive, with a download script and checksums where appropriate. Ignore rules should exclude disposable outputs without accidentally excluding required inputs.

6. **Keep one canonical report per study.** Generate submission copies into `outputs/submission/` rather than maintaining multiple independently updated HTML copies. Export manuscript figures to a documented location within `outputs/`.

7. **Give each study a short README.** State its scientific question, required inputs, command to run, expected outputs, approximate runtime, and exclusions or preprocessing decisions. The root README should start with a quick start and include a map from manuscript figures and supplements to their source files.

## Suggested Migration Plan

1. Resolve the outstanding analysis and reporting issues identified in the repository review, including the empirical temperature weighting, unsupported solver settings, and duplicate equation identifier. Verify any resulting scientific changes separately from the reorganisation.
2. Establish the software environment and reproduction commands while retaining the existing folder layout.
3. Capture a verified baseline of numerical summaries and figures, then move and rename files, updating paths and documentation together.
4. Reproduce the reports and compare them with the baseline to confirm that moving files has not changed the results.
5. Test the documented workflow from a fresh checkout with only the declared software and supplied inputs. Check the full simulation rerun route separately because it is more expensive.

## Decisions for the Project Lead

- Whether to adopt the proposed study numbering and directory names.
- Whether essential simulation outputs should remain in Git or be deposited in a versioned data archive.
- Which historical materials should remain in `archive/` and which can be retained through repository history alone.
- Whether a simple R reproduction script is sufficient initially or a dependency-aware workflow is warranted later.
