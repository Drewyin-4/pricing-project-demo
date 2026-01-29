pricing_base <- readRDS("outputs/pricing_base.rds") %>%
  mutate(
    pure_premium = ultimate / exposure
  )

pricing_base

trend <- 0.05
latest_ay <- max(pricing_base$AY)

pricing_base <- pricing_base %>%
  mutate(
    years_to_latest = latest_ay - AY,
    pure_premium_trended = pure_premium * (1 + trend) ^ years_to_latest
  )

pricing_base

indicated_pp <- weighted.mean(
  pricing_base$pure_premium_trended,
  w = pricing_base$exposure,
  na.rm = TRUE
)

write.csv(pricing_base, "outputs/pricing_base.csv", row.names = FALSE)
writeLines(paste0("indicated_pp=", indicated_pp), "outputs/indicated_pp.txt")

