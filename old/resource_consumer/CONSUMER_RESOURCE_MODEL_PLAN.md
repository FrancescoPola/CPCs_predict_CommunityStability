# Plan for a Consumer-Resource Dynamics Version

This document outlines a plan for adding a consumer-resource dynamics model to
the `community.simulator` package. The aim is to create a model that is
comparable in spirit to the existing temperature-dependent community models, but
where consumers interact indirectly through explicit resources rather than only
through Lotka-Volterra interaction coefficients.

## Aim

Add a consumer-resource model with:

- the same number of resources as consumer species;
- resource consumption governed by Monod uptake functions;
- consumer-specific death rates;
- resource-specific renewal rates;
- consumer by resource matrices for half-saturation constants and maximum
  uptake rates;
- temperature-dependent maximum uptake rates, with Gaussian thermal responses
  whose means and standard deviations are controlled by treatments in the same
  way as the existing discrete-time Lotka-Volterra model.

The first implementation should be usable through the existing experiment
workflow, while preserving the current Lotka-Volterra models.

## Proposed State Variables

For a community with `S` consumer species and `R = S` resources:

- `N_i(t)` is the abundance or biomass of consumer species `i`.
- `R_j(t)` is the concentration or availability of resource `j`.

The model state therefore contains:

```text
N_1, ..., N_S, R_1, ..., R_S
```

## Resource Uptake

Each consumer species can consume each resource. Uptake of resource `j` by
consumer `i` follows a Monod function:

```text
uptake_ij(T, R_j) =
  u_max_ij(T) * R_j / (h_ij + R_j)
```

where:

- `u_max_ij(T)` is the temperature-dependent maximum uptake rate of consumer
  `i` on resource `j`;
- `h_ij` is the half-saturation constant for consumer `i` on resource `j`.

This requires two `S x R` matrices (where S = R):

```text
u_max_ij
h_ij
```

where rows are consumers and columns are resources.

## Temperature Dependence

Maximum uptake should be temperature-dependent. A direct analogue of the
existing Gaussian birth-rate response is:

```text
u_max_ij(T) =
  a_u_ij * exp(-(T - u_opt_ij)^2 / s_u_ij)
```

where:

- `a_u_ij` is the maximum possible uptake height for consumer `i` on resource
  `j`;
- `u_opt_ij` is the thermal optimum of the uptake curve;
- `s_u_ij` controls curve breadth.

The treatment structure should follow the current Lotka-Volterra trait
generation pattern:

- mean of thermal optima;
- range of thermal optima;
- distribution of thermal optima;
- mean of curve breadths;
- range of curve breadths;
- distribution of curve breadths;
- community replicates controlled by community seeds.

For the first implementation, the clearest mapping is probably:

```text
b_opt_* treatments -> u_opt_* treatments
sd_perf_* treatments -> s_u_* treatments
a_b_* treatments -> a_u_* treatments
```

This preserves continuity with the existing experiment-design language, although
new consumer-resource-specific names may be preferable before public use.

## Proposed Continuous-Time Model

A natural first version is:

```text
dN_i / dt =
  N_i * (e_i * sum_j uptake_ij(T, R_j) - d_i) + immigration_i
```

```text
dR_j / dt =
  renewal_j(R_j) - sum_i N_i * uptake_ij(T, R_j)
```

where:

- `e_i` is the conversion efficiency of consumed resource into consumer growth;
- `d_i` is the consumer death rate;
- `renewal_j(R_j)` is resource renewal;
- `immigration_i` is optional low-level consumer immigration, analogous to the
  existing models.

## Resource Renewal

The simplest resource-renewal model is chemostat-like:

```text
renewal_j(R_j) = rho_j * (K_R_j - R_j)
```

where:

- `rho_j` is the renewal rate of resource `j`;
- `K_R_j` is the resource supply concentration or maximum resource level.

This is stable, interpretable, and keeps resources bounded in the absence of
consumers.

An alternative is logistic resource growth:

```text
renewal_j(R_j) = rho_j * R_j * (1 - R_j / K_R_j)
```

The chemostat-like form is probably the better first implementation because it
does not require resources to be self-reproducing populations.

## Proposed Discrete-Time Model

Although consumer-resource dynamics are often implemented in continuous time, a
discrete-time version may be useful for comparison with the current main model.
One possible discrete-time analogue is:

```text
N_i(t + 1) =
  N_i(t) * exp(e_i * sum_j uptake_ij(T_t, R_j(t)) - d_i) + immigration_i
```

```text
R_j(t + 1) =
  R_j(t) + renewal_j(R_j(t)) - sum_i N_i(t) * uptake_ij(T_t, R_j(t))
```

Resource values would need to be constrained to remain non-negative.

However, the first implementation should probably start with continuous time,
because resource consumption and renewal are naturally expressed as coupled ODEs
and this avoids some discrete-time resource overshoot problems.

## Parameter Objects

The community object should be extended, or a new consumer-resource community
object should be created, containing:

```text
S
R
a_u_ij
u_opt_ij
s_u_ij
h_ij
d_i
e_i
rho_j
K_R_j
initial_consumer_abundances
initial_resource_values
```

For the original shared-resource and diagonal resource-use modes, `R` equals
`S`. For the shared-to-private gradient mode, `R = S + 1`: one resource is a
shared resource available to all consumers, and the remaining `S` resources are
consumer-specific private resources.

In the shared-to-private mode, a single specialization parameter `lambda`
controls the resource-use weights:

```text
W_i,shared = 1 - lambda
W_i,private(i) = lambda
```

where `lambda = 0` gives complete shared-resource use and `lambda = 1` gives
one private resource per consumer. Rows of `W` sum to one, so the parameter
changes niche differentiation rather than total feeding capacity.

The most important design choice is whether the matrices vary by consumer only,
by resource only, or by consumer-resource pair. The user request specifies
consumer by resource matrices for half saturation and maximum uptake, so the
implementation should support pair-specific values.

## Experiment-Design Fields

Possible new experiment-design fields:

```json
"dynamics_type": "\"consumer_resource_continuous\"",

"number_of_species_treatment": "c(10)",

"u_max_mean_treatment": 0.3,
"u_max_range_treatment": "c(0)",
"u_max_distribution": "c(\"random_uniform\")",

"u_opt_mean_treatment": "c(20)",
"u_opt_range_treatment": "c(0, 4, 8)",
"u_opt_distribution": "c(\"random_uniform\")",

"sd_u_distribution": "c(\"random_uniform\")",
"sd_u_mean": "c(10)",
"sd_u_range": "c(0)",

"half_saturation_mean_treatment": "c(1)",
"half_saturation_range_treatment": "c(0)",
"half_saturation_distribution": "c(\"random_uniform\")",

"consumer_death_rate_mean_treatment": "c(0.1)",
"consumer_death_rate_range_treatment": "c(0)",
"consumer_death_rate_distribution": "c(\"random_uniform\")",

"resource_renewal_rate_mean_treatment": "c(1)",
"resource_renewal_rate_range_treatment": "c(0)",
"resource_renewal_rate_distribution": "c(\"random_uniform\")",

"resource_supply_mean_treatment": "c(100)",
"resource_supply_range_treatment": "c(0)",
"resource_supply_distribution": "c(\"random_uniform\")",

"resource_use_mode": "c(\"shared_to_private\")",
"resource_specialization": "c(0, 0.25, 0.5, 0.75, 1)",

"conversion_efficiency": 1,
"consumer_immigration_rate": 0.1,
"resource_initial_value": 100
```

For continuity, the first version could optionally map existing field names:

```text
a_b_* -> u_max_*
b_opt_* -> u_opt_*
sd_perf_* -> sd_u_*
```

but explicit consumer-resource names will be easier to understand.

## Implementation Steps

### 1. Add a community-object generator

Add a function such as:

```r
make_a_consumer_resource_community()
```

This should generate all consumer-resource matrices and vectors from the
experiment design and a community seed.

It should support:

- `S` consumers;
- `R = S` resources;
- pair-specific `u_max_ij`;
- pair-specific `u_opt_ij`;
- pair-specific `s_u_ij`;
- pair-specific `h_ij`;
- consumer-specific death rates;
- resource-specific renewal rates;
- resource-specific supply values.

### 2. Add a continuous-time simulator

Add a function such as:

```r
simulator_consumer_resource_continuous()
```

Inputs should include:

- the consumer-resource community object;
- temperature series;
- initial consumer abundances;
- initial resource values;
- output times;
- temperature interpolation mode;
- ODE solver settings.

Use `deSolve::ode()` as for the continuous-time Lotka-Volterra model.

### 3. Define output tables

Consumer dynamics should be written in a form compatible with existing
downstream abundance summaries:

```text
case_id | time | Species_ID | Abundance
```

Resource dynamics should be written separately:

```text
case_id | time | Resource_ID | Resource
```

Possible database files:

```text
dynamics.db
resources.db
temperatures.db
```

Alternatively, both consumers and resources could be written to one long table
with a `state_type` column, but separate tables are probably clearer and safer
for existing downstream functions.

### 4. Add dispatch in `simulate_dynamics()`

Extend `simulate_dynamics()` to dispatch based on:

```json
"dynamics_type": "\"consumer_resource_continuous\""
```

The existing `discrete` and `continuous` Lotka-Volterra branches should remain
unchanged.

### 5. Add summary metrics

Existing community metrics based on consumer abundance should work if the
consumer dynamics table keeps the current schema.

Additional resource-specific summaries may be useful:

- mean total resource availability;
- CV of total resource availability;
- consumer-resource synchrony;
- fraction of time resources are near zero;
- mean realized uptake per consumer;
- mean resource limitation per consumer.

These are not necessary for the first implementation, but they would help
interpret model behaviour.

### 6. Add tests

Minimal tests should verify:

- generated matrices have dimensions `S x S`;
- all generated rates are finite and non-negative;
- the ODE solver returns all requested output times;
- consumer abundances remain non-negative;
- resource values remain non-negative;
- a tiny experiment runs end-to-end;
- existing consumer-abundance summary metrics can be calculated;
- results are reproducible with the same seeds.

### 7. Add example experiment designs

Add at least one tiny example:

- 2 or 3 consumers;
- same number of resources;
- constant temperature;
- short duration;
- one community replicate;
- one environmental replicate.

Then add a fluctuating-temperature example once the constant-temperature case is
stable.

## Suggested First Milestone

The first milestone should be:

1. one tiny continuous-time consumer-resource experiment;
2. `S = R = 3`;
3. constant temperature;
4. one community replicate;
5. one environmental replicate;
6. short burn-in and experiment duration;
7. plots of consumer abundances through time;
8. plots of resource values through time;
9. confirmation that existing consumer community metrics can be calculated.
10. plots of temperature dependence functions

The second milestone should add fluctuating temperature and check that
temperature-dependent maximum uptake produces interpretable consumer and
resource dynamics.

## Open Questions

### Model structure

1. Should consumer growth be based on the sum of uptake across resources, or
   should resources be essential and therefore combined with a minimum or
   multiplicative rule?
   - first case substitutable, so sum of uptake
2. Should every consumer consume every resource, or should there be a sparse
   consumer-resource network?
   - add modes, with the first two being one resource consumed by all, and the second
   being each consumer on a different resource (diagonals non zero, off diagonals zero).
3. Should the diagonal of the consumer-resource matrix represent a consumer's
   preferred resource?
   - yes, but this would be another mode
4. Should off-diagonal resource use be weaker than diagonal use by default?
5. Should `R = S` be hard-coded for this model, or should it be the default with
   support for different numbers of resources later?
   - hard code R = S and then we can manipulate the number of actual resources with the entries of matrices and vectors in the model

### Uptake traits

6. Should `u_max_ij`, `u_opt_ij`, and `s_u_ij` vary by consumer-resource pair,
   by consumer only, or by resource only?
   - these should be possible to vary by consumer-resource pair, but the actual values specified by higher level model parameter / specifications.
7. Should half-saturation constants `h_ij` be temperature-independent, as
   proposed here?
   - no. only max uptake rate
8. Should maximum uptake height `a_u_ij` and thermal optimum `u_opt_ij` be
   correlated?
   - no
9. Should consumers have one thermal optimum shared across all resources, or
   resource-specific thermal optima?
   - one thermal optimum
10. Should the Gaussian uptake function use the same parameterization as the
    existing birth-rate curve, or should it use the more conventional
    `exp(-0.5 * ((T - Topt) / sd)^2)` form?
    - more conventional form

### Resource renewal

11. Should resource renewal be chemostat-like, logistic, or another form?
- chemostate
12. Should resource supply values `K_R_j` vary among resources?
- no
13. Should renewal rates `rho_j` vary among resources?
- no
14. Should resource renewal itself be temperature-dependent?
- no
15. Should resources have an external inflow/outflow interpretation, or be
    treated as regenerating resource populations?
    - inflow outflow

### Consumer demography

16. Should consumer death rates be constant, or temperature-dependent?
- constant
17. Should consumer death rates vary among species?
- no
18. Should there be consumer immigration, as in the current Lotka-Volterra
    model?
    - yes, a little
19. If consumer immigration is included, should resources also have a minimum
    input or floor?
    - only that created by the system dynamics
20. Should conversion efficiency vary among consumers or resources?
- no

### Numerical behaviour

21. Should the model be continuous time only, or should a discrete-time version
    also be implemented?
    - only continuous
22. How should resource depletion be handled numerically when resources approach
    zero?
    - carefully(?)
23. Should negative resource values from solver tolerance be truncated to zero,
    or should the solver stop?
    - stop
24. What abundance or resource thresholds should define numerical blow-up?
- make best guess
25. Should failed cases stop the full experiment, or be recorded and skipped?
- stop

### Comparability

26. Which outputs should be compared directly with the Lotka-Volterra model:
    total consumer biomass, consumer CV, synchrony, CPC metrics, or all of
    these?
    - all, including dynamics of individual populations.
27. Should the same temperature-response treatments be used for `u_max` as were
    used for birth rates in the Lotka-Volterra model?
    - yes
28. Should CPCs be based on consumer uptake curves, expected consumer growth
    curves, or realized consumer performance after resource limitation?
    - expected consumer growth curves
29. How should resource limitation be represented in a community performance
    curve?
    - don't
30. Is the consumer-resource model intended as a sensitivity analysis, or as a
    more mechanistic alternative model for the manuscript?
    - more mechanistic alternative, so not needing to have closely matching dynamics.
