rm(list = ls())
library(plotly)
library(tidyverse)
library(here)
library(patchwork)
library(DT)
library(mgcv)
library(gratia)
library(rlang)
library(vctrs)
library(scales)
library(broom)
library(reshape2)
library(ggtext)
library(ggsci)
library(ggpubr)
library(ggrepel)
library(ggdist)



theme_set(theme_classic())



load(here("Data/empirical study/dens_biomass_mono.RData"))
names(dens)
names(dens)[names(dens)=="mean.dens.ml"]<-"density"

# create day variable

# Convert strings to datetime objects
# Note that for the groups tcl, ds, and p, different dates exist.
# the following code is creating a day. variable and therefore treats these three groups differently
date_format = "%Y-%m-%d"

dens<-dens%>%mutate(date=as.Date(date))

tcl<-dplyr::filter(dens,species_initial%in%c("T","C","L"))
tcl<-mutate(tcl,sample_group="tcl")
earliest_date <- min(tcl$date)
days_since_earliest <- as.numeric(tcl$date - earliest_date) + 1
tcl<-tcl%>%mutate(day=days_since_earliest)

ds<-dplyr::filter(dens,species_initial%in%c("D","S"))
ds<-mutate(ds,sample_group="ds")
earliest_date <- min(ds$date)
days_since_earliest <- as.numeric(ds$date - earliest_date) + 1
ds<-ds%>%mutate(day=days_since_earliest)

p<-dplyr::filter(dens,species_initial%in%c("P"))
p<-mutate(p,sample_group="p")
earliest_date <- min(p$date)
days_since_earliest <- as.numeric(p$date - earliest_date) + 1
p<-p%>%mutate(day=days_since_earliest)

dens<-rbind(tcl,ds,p)

# create a variable called species from only the species initials
L<-dplyr::filter(dens,species_initial=="L")
L<-L%>%mutate(species="Loxocephalus")

D<-dplyr::filter(dens,species_initial=="D")
D<-D%>%mutate(species="Dexiostoma")

S<-dplyr::filter(dens,species_initial=="S")
S<-S%>%mutate(species="Spirostomum")

C<-dplyr::filter(dens,species_initial=="C")
C<-C%>%mutate(species="Colpidium")

P<-dplyr::filter(dens,species_initial=="P")
P<-P%>%mutate(species="Paramecium")

Te<-dplyr::filter(dens,species_initial=="T")
Te<-Te%>%mutate(species="Tetrahymena")

dens<-rbind(P,Te,C,D,S,L)

#dd1 <- dens %>% select("species_initial", "temperature", "nutrients", "sample_ID", "density", "day","species")
# create a data frame with only the days of exponential growth (first 6 days)
dd_d6 <- dens %>% dplyr::filter(day <= 7)


# Group the data by species, nutrient level, temperature, and sample ID
grouped_data <- dens %>%
  group_by(species, nutrients, temperature, sample_ID)

### Calculate carrying capacity (K) as the highest population density for each species and treatment

carrying_capacity_df <- grouped_data %>%
  summarise(
    CarryingCapacity = max(density),
    .groups = 'drop'
  )


### Calculate growth rate as the slope of the linear regression of density ~ time for each species and treatment combination

grouped_data_d6 <- dd_d6 %>%
  group_by(species, nutrients, temperature, sample_ID) %>%
  dplyr::filter(species != "Spirostomum")

grouped_data_d6 <- grouped_data_d6 %>% dplyr::filter(!(species %in% c("Colpidium", "Loxocephalus") & temperature == 28))

growth_rates_df <- grouped_data_d6 %>%
  summarise(
    Intercept = coef(lm(log(density + 0.001) ~ day))[1],
    GrowthRate = coef(lm(log(density + 0.001) ~ day))[2],
    RSquared = summary(lm(log(density + 0.001) ~ day))$r.squared,
    .groups = 'drop'
  )


spiro_r_df <- dens %>% dplyr::filter(species == "Spirostomum") %>%
  group_by(species, nutrients, temperature, sample_ID)

spiro_r <-  spiro_r_df %>%
  summarise(
    Intercept = coef(lm(log(density + 0.001) ~ day))[1],
    GrowthRate = coef(lm(log(density + 0.001) ~ day))[2],
    RSquared = summary(lm(log(density + 0.001) ~ day))$r.squared,
    .groups = 'drop'
  )



colp_28 <- dens %>% dplyr::filter((species %in% "Colpidium" & temperature == 28)) %>%
  dplyr::filter(day <= 3) %>%
  group_by(species, nutrients, temperature, sample_ID)

colp_28_r <- colp_28 %>% summarise(
  Intercept = coef(lm(log(density + 0.001) ~ day))[1],
  GrowthRate = coef(lm(log(density + 0.001) ~ day))[2],
  RSquared = summary(lm(log(density + 0.001) ~ day))$r.squared,
  .groups = 'drop'
)


loxo_28 <- dens %>% dplyr::filter((species %in% "Loxocephalus" & temperature == 28)) %>%
  dplyr::filter(day <= 3) %>%
  group_by(species, nutrients, temperature, sample_ID)

loxo_28_r <- loxo_28 %>% summarise(
  Intercept = coef(lm(log(density + 0.001) ~ day))[1],
  GrowthRate = coef(lm(log(density + 0.001) ~ day))[2],
  RSquared = summary(lm(log(density + 0.001) ~ day))$r.squared,
  .groups = 'drop'
)

growth_rates_df <- rbind(growth_rates_df, spiro_r, loxo_28_r, colp_28_r)

# Display the resulting carrying capacity and growth rate data frames
dd_r_K <- merge(growth_rates_df, carrying_capacity_df, by = c("species", "nutrients", "temperature", "sample_ID"))

# change place holder nutrient levels to actual numerical values

dd_r_K_1<-mutate(dplyr::filter(dd_r_K,nutrients==1),nutrients=0.01)
dd_r_K_2<-mutate(dplyr::filter(dd_r_K,nutrients==2),nutrients=0.75)
dd_r_K_3<-mutate(dplyr::filter(dd_r_K,nutrients==3),nutrients=1.25)
dd_r_K_4<-mutate(dplyr::filter(dd_r_K,nutrients==4),nutrients=2.5)
dd_r_K_5<-mutate(dplyr::filter(dd_r_K,nutrients==5),nutrients=3)

dd_r_K_new<-rbind(dd_r_K_1,dd_r_K_2,dd_r_K_3,dd_r_K_4,dd_r_K_5)
dd_r_K<-dd_r_K_new


# Fit GAMS to calculated growth rate to estimate response surface

new_data <- expand_grid(temperature = seq(18, 28, by= 0.02),
                        nutrients = seq(0.01, 3, by= 0.01))


nested_gams <- dd_r_K %>%
  nest(cols =-species) %>%
  mutate(
    gams = map(cols, ~ gam(GrowthRate ~ te(temperature, nutrients, k = c(5, 5)),
                           data = .x,
                           method = "REML")),
    predicted = map(gams, ~ predict(.x, newdata = new_data))
  )


# Creating the dataset with the 2 columns as described above
predicted <- nested_gams %>% unnest(predicted)
rates <- cbind(new_data, predicted[, c(1,4)])
rates <- rates %>%
  relocate(species, temperature, nutrients, predicted)



new_nested_gams<-nested_gams%>%dplyr::filter(species!="Tetrahymena")


pred_slice<-function(nutrient_level){

  new_data <- expand_grid(temperature = seq(18, 28, by= 0.02),
                          nutrients = rep(nutrient_level))
  num_rows <- nrow(new_data)

  pred_slice <- data.frame(matrix(nrow = num_rows, ncol = 0))

  for (j in 1:length(new_nested_gams$species)) {
    predictions <- unlist(map(nested_gams$gams[j], ~ predict(.x, newdata = new_data)))
    pred_slice <- bind_rows(pred_slice, data.frame(prediction = predictions, species = new_nested_gams$species[j],temp_expand=new_data$temperature))
  }

  pred_slice <- na.omit(pred_slice)

  pred_slice<-cbind(pred_slice,new_data)

  return(pred_slice)}



# read info_communities from empirical experiment


info_communities <- read_csv(here("Data/empirical study/", "info_communities.csv"))



T_scenarios <- list(
  c(18, 21),
  c(22, 25),
  c(25, 28)
)



df_performance <- lapply(T_scenarios,function(T){
  nutrients<-c(0.01,0.35,0.75)
  slopes<-lapply(nutrients,function(N){
    df<-pred_slice(N)
    df_filtered<-df%>%dplyr::filter(temperature >= T[1] & temperature <= T[2])%>%
      mutate(temperature=paste0(min(temperature),"-",max(temperature)," °C"),
             nutrients=paste0(nutrients," g/L"))


    return(df_filtered)

  })
  slopes<-do.call("rbind",slopes)
  slopes  <-slopes%>%mutate(species_initial=sapply(strsplit(species,""),"[",1))

  ### delta in performance divided by the delta temperature


  return(slopes)

})

perf_curves<-do.call(rbind,df_performance)

l_comm_perf<-apply(info_communities,1, function(r){
  df<-perf_curves%>%dplyr::filter(temperature==(r["temperature"]) & nutrients==(r["nutrients"]),
                           species_initial %in% unlist(strsplit(r["composition"], "")))

  com_perf<-df%>%group_by(temperature,nutrients,temp_expand)%>%summarise(com_pred=sum(prediction),composition=unique(r["composition"]))

  CV_com_perf<-com_perf%>%group_by(temperature,nutrients,composition)%>%summarise(cv_com=sd(com_pred)/abs(mean((com_pred))))
  return(CV_com_perf)
})


df_cv_perf<-do.call("rbind",l_comm_perf)

# read complete_aggr
empirical_results <- read.csv(here("Data/empirical study/", "empirical_results.csv"))



df_cv_perf <- full_join(df_cv_perf, empirical_results, by = c("composition", "nutrients", "temperature"))


a <- ggplot(df_cv_perf, aes(x = log10(cv_com), y = log10(CV))) +
  geom_point(
    color = "grey40",   # darker grey
    alpha = 0.45,       # transparent but visible
    size = 1.8
  ) +
  geom_smooth(
    method = "lm",
    color = "#3B5C7A",
    fill  = "#3B5C7A",
    alpha = 0.18,
    linewidth = 1.4
  ) +
  theme_bw(base_size = 18) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    strip.text = element_text(face = "bold")
  ) +
  labs(
    x = "Log10 CV of community performance",
    y = "Log10 Instability of empirical community biomass",
    tag = "(a)"
  )



# ### Plotting for various communities
#
# ## Get all unique composition × temperature × nutrients combinations
# comps <- empirical_results %>%
#   distinct(composition, temperature, nutrients, richness)
#
# # try plot 1 temperature regime
#
# df1 <- df_performance[[3]]
#
#
#
# df1_clean <- comps %>%
#   mutate(species_initial = str_split(composition, "", simplify = FALSE)) %>%
#   unnest(species_initial) %>%
#   left_join(df1,
#             by = c("temperature", "nutrients", "species_initial"),
#             relationship = "many-to-many") %>%
#   dplyr::filter(!is.na(prediction)) %>%
#   group_by(composition, temp_expand) %>%
#   mutate(community_sum = sum(prediction)) %>%
#   ungroup()
#
# ggplot(df1_clean, aes(x = temp_expand, y = prediction, color = species)) +
#   geom_line(size = 0.8) +
#   geom_line(aes(y = community_sum), color = "black", size = 1.2) +
#   facet_wrap(nutrients ~ composition) +
#   scale_color_brewer(palette = "Dark2") +
#   theme_bw() +
#   labs(
#     title = "Species predictions per composition",
#     x = "Temperature (°C)",
#     y = "Predicted growth rate"
#   ) +
#   theme(legend.position = "bottom")
#
# # create plots for all regimes
# make_clean_plot <- function(df_performance, comps, idx) {
#   df <- df_performance[[idx]]
#
#   # Build merged dataset
#   df_clean <- comps %>%
#     mutate(species_initial = str_split(composition, "", simplify = FALSE)) %>%
#     unnest(species_initial) %>%
#     left_join(df,
#               by = c("temperature", "nutrients", "species_initial"),
#               relationship = "many-to-many") %>%
#     dplyr::filter(!is.na(prediction)) %>%
#     group_by(composition, temp_expand) %>%
#     mutate(community_sum = sum(prediction)) %>%
#     ungroup()
#
#   # Extract temp range for title
#   temp_min <- min(df_clean$temp_expand, na.rm = TRUE)
#   temp_max <- max(df_clean$temp_expand, na.rm = TRUE)
#   temp_range <- paste0(temp_min, "–", temp_max, " °C")
#
#   # Plot
#   ggplot(df_clean, aes(x = temp_expand, y = prediction, color = species)) +
#     geom_line(size = 0.8) +
#     geom_line(aes(y = community_sum), color = "black", size = 1.2) +
#     facet_wrap(nutrients ~ composition) +
#     scale_color_brewer(palette = "Dark2") +
#     theme_bw() +
#     labs(
#       title = paste("Species predictions per composition (", temp_range, ")", sep = ""),
#       x = "Temperature (°C)",
#       y = "Predicted growth rate"
#     ) +
#     theme(legend.position = "bottom")
# }
#
# make_clean_plot(df_performance, comps, 1)
# make_clean_plot(df_performance, comps, 2)
# make_clean_plot(df_performance, comps, 3)


#### Mean and Variance

# get position of the optima
temp_optima <- df_performance %>%
  bind_rows() %>%  # combine all 3 datasets
  group_by(species, nutrients, temperature) %>%
  summarise(
    temp_opt = temp_expand[which.max(prediction)],
    max_growth = max(prediction),
    .groups = "drop"
  )

temp_optima

# Calculate mean and variance of optima for each community
species_map <- c(
  C = "Colpidium",
  D = "Dexiostoma",
  P = "Paramecium",
  L = "Loxocephalus",
  S = "Spirostomum"
)


community_species <- info_communities %>%
  mutate(species_initial = strsplit(composition, "")) %>%  # split letters
  unnest(species_initial) %>%                               # one row per species
  mutate(species = species_map[species_initial])           # map letters to full species names

# Step 2: Merge with species temp_optima
community_optima_merged <- community_species %>%
  left_join(temp_optima, by = c("species", "temperature", "nutrients"))

# View the merged dataset
community_optima_merged

community_stats <- community_optima_merged %>%
  group_by(composition, temperature, nutrients) %>%
  summarise(
    mean_opt = mean(temp_opt, na.rm = TRUE),
    var_opt = sd(temp_opt, na.rm = TRUE),
    .groups = "drop"
  )


#
# names(df_cv_perf)
# names(empirical_results_summary_stats)
# Merge with empirical results
empirical_results_summary_stats <- full_join(empirical_results, community_stats,
                                          by = c("composition", "temperature", "nutrients"))

empirical_results_summary_stats <- empirical_results_summary_stats %>%
  rowwise() %>%
  mutate(
    temp_low  = as.numeric(str_extract(temperature, "^\\d+\\.?\\d*")),   # first number
    temp_high = as.numeric(str_extract(temperature, "(?<=-)\\d+\\.?\\d*")), # number after -
    temp_mid  = (temp_low + temp_high) / 2,
    distance_mean_env = abs(mean_opt - temp_mid)
  ) %>%
  ungroup() %>%
  select(-temp_low, -temp_high, -temp_mid)  # optional cleanup

empirical_results_summary_stats <- full_join(empirical_results_summary_stats, df_cv_perf,
                                             by = c("composition", "temperature", "nutrients", "richness", "CV"))


write.csv(empirical_results_summary_stats, "Data/empirical_results_summary.csv", row.names = FALSE, quote = FALSE)

# Plot CV of biomass vs mean and variance of optima
p1 <- ggplot(empirical_results_summary_stats, aes(x = var_opt, y = log10(CV))) +
  geom_point(
    color = "grey40",   # darker grey
    alpha = 0.45,       # transparent but visible
    size = 1.8
  ) +
  geom_smooth(
    method = "lm",
    color = "#3B5C7A",
    fill  = "#3B5C7A",
    alpha = 0.18,
    linewidth = 1.4
  ) +
  theme_bw(base_size = 25) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    strip.text = element_text(face = "bold")
  ) +
  labs(
    x = "SD of species' thermal optima (°C)",
    y = "Instability\nLog10 of empirical community biomass",
    tag = "(b)"
  )


p2 <- ggplot(empirical_results_summary_stats, aes(x = distance_mean_env, y = log10(CV))) +
  geom_point(
    color = "grey40",   # darker grey
    alpha = 0.45,       # transparent but visible
    size = 1.8
  ) +
  geom_smooth(
    method = "lm",
    color = "#3B5C7A",
    fill  = "#3B5C7A",
    alpha = 0.18,
    linewidth = 1.4
  ) +
  theme_bw(base_size = 25) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    strip.text = element_text(face = "bold")
  ) +
  labs(
    x = "Mean distance' thermal optima (°C)",
    y = "Instability\nLog10 of empirical community biomass",
    tag = "(c)"
  )


a <- ggplot(empirical_results_summary_stats, aes(x = log10(cv_com), y = log10(CV))) +
  geom_point(
    color = "grey40",   # darker grey
    alpha = 0.45,       # transparent but visible
    size = 1.8
  ) +
  geom_smooth(
    method = "lm",
    color = "#3B5C7A",
    fill  = "#3B5C7A",
    alpha = 0.18,
    linewidth = 1.4
  ) +
  theme_bw(base_size = 25) +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    strip.text = element_text(face = "bold")
  ) +
  labs(
    x = "Log10 CV of community performance",
    y = "Instability\nLog10 of empirical community biomass",
    tag = "(a)"
  )



#### Figure 4 ###
combined_plot <- a + p1 + p2
combined_plot
# Save the figure
# ggsave(
#   filename = "Figure4.png",
#   plot = combined_plot,
#   width = 25,           # Width in inches
#   height = 12,          # Height in inches (adjust based on your layout)
#   dpi = 300,            # High resolution for print/big screens
#   limitsize = FALSE     # Allows saving even if dimensions are very large
# )


# merge dfs
empirical_results_summary_stats1 <- left_join(empirical_results_summary_stats, df_cv_perf, by = c("composition", "richness", "temperature", "nutrients", "CV"))

# define your models in a list
models <- list(
  naive = as.formula("log10(CV) ~ log10(cv_com.x)"),
  var   = as.formula("log10(CV) ~ var_opt"),
  mean    = as.formula("log10(CV) ~ mean_opt"),
  trait_summaries = as.formula("log10(CV) ~ var_opt * mean_opt"))



# run models for each unique sd_perf_mean
results <- empirical_results_summary_stats1 %>%
  #group_by(composition) %>%
  group_modify(~ {
    map_df(models, function(f, dat) {
      fit <- lm(f, data = dat)
      tibble(r2 = summary(fit)$r.squared,
             df_red=fit$df.residual)
    }, dat = .x, .id = "model")
  }) %>%
  ungroup()

results <- results %>%
  mutate(
    model = factor(
      model,
      levels = c("naive", "var", "mean", "trait_summaries"),
      labels = c(
        "Naïve",
        "SD Topt",
        "Mean Topt",
        "Trait summaries"
      )
    )
  )

ggplot(results, aes(x = model, y = r2)) +

  # 1. PLOT POINTS FIRST (Background)
  geom_point(
    aes(colour = model),
    alpha = 0.30, size = 3
  ) +

  # 2. PLOT DISTRIBUTION SECOND (Foreground)
  stat_halfeye(
    side           = "left",
    aes(fill = model),
    color          = "black",       # <--- Makes the dot & bar black/visible
    slab_alpha     = 0.25,          # Transparency of the violin part
    interval_alpha = 1,             # Make the bar fully opaque
    point_alpha    = 1,             # Make the dot fully opaque
    .width         = c(0.5, 0.8),
    adjust         = 0.8,
    justification  = 1.05,
    point_interval = "median_qi"
  ) +

  # Scales and Themes
  scale_fill_viridis_d(option = "C", end = 0.95) +
  scale_colour_viridis_d(option = "C", end = 0.85) +
  theme_bw(base_size = 25) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "grey92"),
    strip.text       = element_text(face = "bold")
  ) +
  labs(
    y = expression(paste("Explanatory power of community metric (", R^2, ")"))
  )

summary(lm(log10(CV) ~ var_opt, data = empirical_results_summary_stats1))
summary(lm(log10(CV) ~ mean_opt, data = empirical_results_summary_stats1))
summary(lm(log10(CV) ~ var_opt * mean_opt, data = empirical_results_summary_stats1))
summary(lm(log10(CV) ~ log10(cv_com.x ), data = empirical_results_summary_stats1))

ggplot(empirical_results_summary_stats, aes(x = log10(distance_mean_env), y = log10(CV), col = richness)) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  theme_bw() +
  labs(
    x = "Log10 CV of community performance",
    y = "Log10 CV of empirical of community biomass"
  ) +
  facet_wrap(temperature~nutrients)





# across all environments
# get position of the optima
temp_optima <- df_performance %>%
  bind_rows() %>%  # combine all 3 datasets
  group_by(species) %>%
  summarise(
    temp_opt = temp_expand[which.max(prediction)],
    max_growth = max(prediction),
    .groups = "drop"
  )

temp_optima

# Calculate mean and variance of optima for each community
species_map <- c(
  C = "Colpidium",
  D = "Dexiostoma",
  P = "Paramecium",
  L = "Loxocephalus",
  S = "Spirostomum"
)


community_species <- info_communities %>%
  mutate(species_initial = strsplit(composition, "")) %>%  # split letters
  unnest(species_initial) %>%                               # one row per species
  mutate(species = species_map[species_initial])           # map letters to full species names

# Step 2: Merge with species temp_optima
community_optima_merged <- community_species %>%
  left_join(temp_optima, by = c("species"))

# View the merged dataset
community_optima_merged

community_stats <- community_optima_merged %>%
  group_by(composition, temperature, nutrients) %>%
  summarise(
    mean_opt = mean(temp_opt, na.rm = TRUE),
    var_opt = var(temp_opt, na.rm = TRUE),
    .groups = "drop"
  )


# Merge with empirical results
empirical_results_summary_stats <- full_join(empirical_results, community_stats,
                                             by = c("composition", "temperature", "nutrients"))


# Plot CV of biomass vs mean and variance of optima
p1 <- ggplot(empirical_results_summary_stats, aes(x = var_opt, y = log10(CV))) +
  geom_point() +
  geom_smooth(method = "lm", se = TRUE) +
  theme_bw() +
  labs(
    x = "Mean of species' thermal optima (°C)",
    y = "Log10 CV of empirical community biomass"
  )

