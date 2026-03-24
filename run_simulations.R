
rm(list = ls())


Sys.setenv(GITHUB_PAT = "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")
remotes::install_github("opetchey/community.simulator",
                       build_vignettes = TRUE, force = TRUE)


## Use the next line to add a package to the DESCRIPTION file
#usethis::use_package("dplyr")

library(tidyverse)
library(zoo)
library(readxl)
library(here)
library(kableExtra)
library(patchwork)
library(primer)
library(DBI)
library(RSQLite)
library(dplyr)
library(dirmult)
library(jsonlite)
library(tidyverse)
library(readxl)
library(MESS)
library(here)
library(patchwork)
library(DBI)
library(RSQLite)
library(broom)
library(tidyr)
library(purrr)
library(gratia)
library(community.simulator)

## Use this to load the package with any changes made to functions
devtools::load_all()

## make a path to the desktop for saving data
## While developing and testing, it can be useful to use the inst folder of the package as the location for the experiment
experiment_folder_location <- "~/experiments"
experiment_name <- "final"
experiment_design_filename <- paste0(experiment_name, "_v0.7.json")

## create folder for experiment, if it does not already exist
experiment_folder <- create_experiment_folder(experiment_folder_location, experiment_name)

## **Now put the experiment definition json in the experiment folder. You can get a template of this file from the inst/ folder of the package.**

## Create experiment table
create_experiment_table(experiment_folder, experiment_design_filename)

# alpha_ij_sd == 0 but alpha_ij_mean > 0 because we don't want cases where all interactions are non-zero and identical

expt <- readRDS(paste0(experiment_folder, "experiment_table.RDS"))
expt<-expt %>% filter( !(alpha_ij_sd > 0 & alpha_ij_mean == 0) & !(alpha_ij_sd == 0 & alpha_ij_mean > 0))
saveRDS(expt, paste0(experiment_folder, "experiment_table.RDS"))


## Create environments
create_environments(experiment_folder, experiment_design_filename)

## Simulate dynamics
simulate_dynamics(
  experiment_folder, experiment_design_filename)

## Get temporal derivatives
get_temporal_derivatives(experiment_folder, experiment_design_filename, every_t = 10)%>%suppressMessages()

## Get arbitrary derivatives
get_arbitrary_derivatives(experiment_folder, experiment_design_filename)%>%suppressMessages()

## Get temporal derivatives
get_delta_igr(experiment_folder, experiment_design_filename, every_t = 1)


## Get the community measures
get_community_measures(experiment_folder, experiment_design_filename)

# ## get CV of sum of igrs
# community_igr_CV <- get_CV_com_perf_final(experiment_folder,
#                                     experiment_design_filename,
#                                     every_t = 1)%>%suppressMessages()
#
# community_measures <- readRDS(paste0(experiment_folder, "community_measures.RDS"))
# community_measures<-full_join(community_igr_CV,community_measures)






## Make plots for one community
# Does only work If functions for derivatives have been run

# expt <- readRDS(paste0(experiment_folder, "experiment_table.RDS"))
# case_id_oi <-expt$case_id[756]
# graphs <- make_plots_for_one_community(experiment_folder, case_id_oi)
# graphs$p_igrtemp / graphs$p_tempseries / graphs$p_dynamics
#









graphs$p_tempseriesgraphs$timep_tempseries
graphs$p_temphist
graphs$p_igrtemp
#graphs$p_igrhist
graphs$p_igrderivtemp
graphs$p_comm_div_temp_mean
graphs$p_dynamics

graphs$p_igrtemp / graphs$p_tempseries / graphs$p_dynamics


## Make a graph of stability versus sum of derivatives
#community_measures <- readRDS(paste0(experiment_folder, "community_measures.RDS"))
#community_measures <- full_join(community_measures, expt, by = "case_id")

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = CV_community_perf_info,
             y = CV_totab,
             col = as_factor(b_opt_mean),
             shape = as_factor(richness))) +
  geom_point()+
  facet_wrap(alpha_ij_mean~alpha_ij_sd)

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = CV_community_perf_naive,
             y = CV_totab,
             col = as_factor(b_opt_mean),
             shape = as_factor(richness))) +
  geom_point()+
  facet_wrap(alpha_ij_mean~alpha_ij_sd)


community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = abs(20-real_mean_b_opt),
             y = CV_community_perf_naive,
             col = as_factor(b_opt_mean),
             shape = as_factor(richness))) +
  geom_point()

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = real_sd_b_opt,
             y = CV_totab,
             col = abs(20-real_mean_b_opt),
             shape = as_factor(richness))) +
  geom_point()+
  facet_grid(sd_perf_mean~sd_perf_range)

# Check if synchrony works the way we think it does
community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = synchrony_perf_info,
             y = CV_totab,
             col = abs(20-real_mean_b_opt),
             shape = as.factor(richness))) +
  geom_point()

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = synchrony_perf_naive,
             y = CV_totab,
             col = as.factor(sd_perf_mean),
             shape = as.factor(richness))) +
  geom_point()


community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = synchrony_perf_naive,
             y = sync_ab,
             col = alpha_ij_sd),
             shape = as.factor(richness)) +
  geom_point()

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = synchrony_perf_info,
             y = sync_ab,
             col = alpha_ij_sd),
         shape = as.factor(richness)) +
  geom_point()

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = CV_totab,
             y = pop_CV_ab,
             col = alpha_ij_sd),
         shape = as.factor(richness)) +
  geom_point()

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(y = log(CV_totab),
             x = log(sync_ab),
             col = alpha_ij_sd),
         shape = as.factor(richness)) +
  geom_point()



community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = avg_perf_CV_info,
             y = pop_CV_ab,
             col = alpha_ij_sd),
         shape = as.factor(richness)) +
  geom_point()


community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = avg_perf_CV_naive,
             y = pop_CV_ab,
             col = alpha_ij_sd),
         shape = as.factor(richness)) +
  geom_point()+
  geom_smooth(method = "lm")



mod1 <- filter(community_measures,
               real_mean_b_opt > 16 &
                 real_mean_b_opt < 24) %>%
  lm(CV_totab ~ abs(20-real_mean_b_opt) + real_sd_b_opt , data = .)
summary(mod1)

mod2 <- filter(community_measures,
               real_mean_b_opt > 16 &
                 real_mean_b_opt < 24,CV_totab<30) %>%
  lm(CV_totab ~ CV_community_perf_naive , data = .)
summary(mod2)

mod3 <- filter(community_measures,
               real_mean_b_opt > 16 &
                 real_mean_b_opt < 24) %>%
  lm(CV_totab ~ CV_community_perf_info, data = .)
summary(mod3)

mod4 <- filter(community_measures,
               real_mean_b_opt > 16 &
                 real_mean_b_opt < 24,alpha_ij_sd==0) %>%
  lm(CV_totab ~ CV_community_perf_info + real_mean_b_opt * real_sd_b_opt + richness, data = .)
summary(mod4)



mod10 <- filter(community_measures,
                real_mean_b_opt > 16 &
                  real_mean_b_opt < 24) %>%
  lm(CV_community_perf_naive ~ abs(20-real_mean_b_opt) + real_sd_b_opt , data = .)
summary(mod10)



community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24) |>
  ggplot(aes(x = abs(20-real_mean_b_opt),
             y = CV_totab,
             col = as_factor(b_opt_mean),
             shape = as_factor(richness))) +
  geom_point()+
  facet_wrap(alpha_ij_mean~alpha_ij_sd)

community_measures |>
  filter(real_mean_b_opt > 16 &
           real_mean_b_opt < 24,) |>
  ggplot(aes(x = real_sd_b_opt,
             y = CV_totab,
             col = as_factor(b_opt_mean),
             shape = as_factor(richness))) +
  geom_point()+
  facet_wrap(alpha_ij_mean~alpha_ij_sd)
