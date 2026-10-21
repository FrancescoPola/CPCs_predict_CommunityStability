# Factorial Consumer-Resource Stability Experiment 2

This plan matches `factorial2.json`.

## Aim

Extend the first factorial experiment by adding variation in species richness
and community replication. The goal is to test whether the relationship between
community viability variability and total-abundance stability generalizes across
larger and more variable consumer-resource communities.

## Model

The experiment uses the continuous-time consumer-resource model with:

- 4, 8, or 12 consumer species;
- one shared resource plus one private resource per consumer;
- Monod resource uptake;
- Gaussian temperature dependence of maximum uptake;
- chemostat-like resource renewal;
- consumer immigration;
- fluctuating temperature time series.

Resource use follows `resource_use_mode = "shared_to_private"`:

```text
resource_specialization = 0  all consumers use only the shared resource
resource_specialization = 1  each consumer uses only its private resource
```

## Experimental Design

The JSON varies:

```r
number_of_species_treatment = c(4, 8, 12)
resource_specialization = seq(0, 1, length.out = 5)
u_opt_mean_treatment = c(16, 20, 24)
u_opt_range_treatment = c(0, 2, 4)
sd_u_mean = c(1, 2, 3)
```

It also uses:

```r
number_of_community_replicates = 5
number_of_environment_replicates = 5
```

This gives:

```text
3 richness levels *
5 resource-specialization levels *
3 thermal-optimum means *
3 thermal-optimum ranges *
3 thermal breadths *
5 community replicates *
5 temperature replicates
= 10,125 simulation cases
```

## Fixed Parameters

Important fixed model parameters are:

```json
"random_seed": 20260618,
"dynamics_type": "\"consumer_resource_continuous\"",
"u_max_mean_treatment": "c(0.06)",
"u_max_range_treatment": "c(0)",
"u_max_distribution": "c(\"random_uniform\")",
"u_opt_distribution": "c(\"random_uniform\")",
"sd_u_distribution": "c(\"random_uniform\")",
"sd_u_range": "c(0.5)",
"half_saturation_mean_treatment": "c(100)",
"half_saturation_range_treatment": "c(0)",
"consumer_death_rate_treatment": "c(0.03)",
"resource_renewal_rate_treatment": "c(1)",
"resource_supply_treatment": "c(1000)",
"conversion_efficiency": "c(1)",
"resource_use_mode": "c(\"shared_to_private\")",
"active_resource": 1
```

Compared with experiment 1, thermal optima are randomly distributed and
`sd_u_range = c(0.5)`, so species can differ in thermal breadth within a
community.

## Environmental Forcing

Temperature is generated with:

```json
"temperature_mean": 20,
"temperature_sd": 4,
"one_over_f_gamma": 1,
"temperature_series_control": "c(\"same_per_replicate\")"
```

Each case has:

```json
"burn_in_duration": 20,
"experiment_duration": 50000
```

## Dynamics And Output

ODE and output settings are:

```json
"consumer_immigration_rate": 0.01,
"initial_consumer_total_abundance": 30,
"resource_initial_value": 1000,
"temperature_interpolation": "\"linear\"",
"ode_method": "\"lsoda\"",
"ode_rtol": 1e-6,
"ode_atol": 1e-8,
"ode_max_step": 1,
"blowup_threshold": 1e12,
"negative_tolerance": 1e-8,
"dynamics_save_every": 10
```

Consumer and resource dynamics are saved every 10 time steps.

## Parallel Processing

The JSON enables parallel simulations:

```json
"parallel_simulations": "TRUE",
"parallel_workers": "max(1, parallel::detectCores(logical = FALSE) - 1)",
"initial_abundance_seed_base": 4242
```

## Main Responses

Primary response:

```text
CV_totab = sd(total consumer abundance) / mean(total consumer abundance)
```

Primary predictors:

- `CV_community_viability_binary_info`;
- `CV_community_viability_soft_info`;
- `resource_specialization`;
- richness;
- thermal-optimum mean, range, and breadth.

## Planned Analysis

The main analysis should test whether the viability-CPC result from experiment 1
persists after adding richness and replication:

```r
1 / CV_totab ~
  CV_community_viability_binary_info *
  richness +
  resource_specialization +
  u_opt_mean +
  u_opt_range +
  sd_u_mean
```

Because this experiment has many more cases, it is also appropriate for
checking nonlinearities and interactions with GAMs or tree-based exploratory
models.
