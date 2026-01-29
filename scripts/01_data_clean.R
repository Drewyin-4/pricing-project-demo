library(dplyr)
library(tidyr)


df <- read.csv("meyers_triangles_long.csv")
str(df)
unique(df$loss_type)
unique(df$line)
unique(df$segment)
exp <- read.csv("meyers_exposure.csv")
str(exp)
head(exp)
names(exp)
unique(exp$line)
exp_ay <- exp %>%
  filter(line == "ppauto") %>%
  group_by(accident_year) %>%
  summarise(exposure = sum(exposure, na.rm = TRUE)) %>%
  arrange(accident_year)

df_pr <- df %>%
  filter(
    line == "ppauto",
    loss_type == "ultimate",
    segment == "train"
  )

ult_ay <- df_pr %>%
  group_by(accident_year) %>%
  slice_max(
    order_by = development_lag,
    n = 1,
    with_ties = FALSE
  ) %>%
  ungroup() %>%
  transmute(
    AY = accident_year,
    ultimate = value,
    dev_used = development_lag
  ) %>%
  arrange(AY)


pricing_base <- ult_ay %>% 
  left_join(exp_ay, by = c("AY" = "accident_year"))

saveRDS(pricing_base, "outputs/pricing_base.rds")
