# Publication Experiments, YAML Version

This folder contains a runnable YAML-specification version of the four active
publication experiments from `publication_experiments 20260718`.

The original folder is left untouched. This folder contains only experiment
specifications, a runner script, and the report source. It deliberately omits
old output files so the experiments can be rerun with the rewritten
`community.simulator` YAML workflow.

| Folder | YAML file | Purpose | Main treatment mode | Expected cases |
| --- | --- | --- | --- | ---: |
| `data/LV1` | `canonical_01_lv_factorial_publication.yaml` | Larger discrete LV publication experiment, compact summaries only | Uniform asymmetric competition gradient | 7290 |
| `data/LV2` | `canonical_02_lv_factorial_publication.yaml` | Larger discrete LV publication experiment, compact summaries only | Log-normal symmetric competition gradient | 7290 |
| `data/CR1` | `canonical_01_cr_factorial_publication.yaml` | Larger consumer-resource publication experiment, compact summaries only | Deterministic private-resource-use gradient | 7290 |
| `data/CR2` | `canonical_02_cr_factorial_publication.yaml` | Larger consumer-resource publication experiment, compact summaries only | Stochastic beta private-resource-use gradient | 7290 |

## Run

Open this folder in R or set it as the working directory, then run:

```r
source("run_all.R")
```

At the top of `run_all.R` there is commented code for installing the current
Codex branch version of `community.simulator` from GitHub before running the
experiments.

## Notes

- YAML files are declarative and do not contain R expressions.
- The large experiments save compact summaries only; they do not save full
  `dynamics.db` or `resources.db` outputs.
- After running the experiments, render `stability_cpc_report.qmd` to inspect
  community stability and CPC/viability relationships.
