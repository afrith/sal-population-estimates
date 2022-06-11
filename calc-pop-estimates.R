library(readr)
library(tidyr)
library(dplyr)

lm_est_wide <- read_csv("sources/lm-projections.csv")
lm_est_long <- gather(lm_est_wide, year, pop_est, `2002`:`2031`)
lm_pop_est <- lm_est_long %>% filter(year >= 2008, year <= 2022) %>% group_by(Loc_Code, year) %>% summarise(pop_est = sum(pop_est), .groups = "drop")
remove(lm_est_wide, lm_est_long)

dc_est1_wide <- read_csv("sources/district-projections-2002-2021.csv")
dc_est1_long <- gather(dc_est1_wide, year, pop_est, `2002`:`2021`)
dc_est2_wide <- read_csv("sources/district-projections-2022-2026.csv")
dc_est2_long <- gather(dc_est2_wide, year, pop_est, `2022`:`2026`)
dc_est_long <- bind_rows(dc_est1_long, dc_est2_long)
dc_pop_est <- dc_est_long %>% filter(year >= 2008, year <= 2022) %>% group_by(Name, year) %>% summarise(pop_est = sum(pop_est), .groups = "drop")
rm(dc_est1_wide, dc_est1_long, dc_est2_wide, dc_est2_long, dc_est_long)

metros <- data.frame(
  Name = c("EC - Buffalo City Metropolitan Municipality",
    "EC - Nelson Mandela Bay Metropolitan Municipality",
    "FS - Mangaung Metropolitan Municipality (MAN)",
    "GT - City of Johannesburg Metropolitan Municipality",
    "GT - City of Tshwane Metropolitan Municipality",
    "GT - Ekurhuleni Metropolitan Municipality",
    "KZN - eThekwini Metropolitan Municipality",
    "WC - City of Cape Town Metropolitan Municipality"
  ),
  Loc_Code = c("BUF", "NMA", "MAN", "JHB", "TSH", "EKU", "ETH", "CPT")
)
metro_pop_est <- inner_join(dc_pop_est, metros, by = "Name") %>%
  transmute(Loc_Code = Loc_Code, year = year, pop_est = pop_est)

muni_pop_est <- bind_rows(lm_pop_est, metro_pop_est) %>%
  transmute(muni_code = Loc_Code, year = as.factor(year), pop_est = pop_est)
rm(dc_pop_est, lm_pop_est, metros, metro_pop_est)

muni_pop_census <- read_csv("sources/muni-pop-census2011.csv")
muni_pop_growth <- inner_join(muni_pop_est, muni_pop_census, by = "muni_code") %>%
  transmute(muni_code = as.factor(muni_code), year = year, factor_rel_2011 = pop_est / pop_2011)

sal_pop <- read_csv("sources/sal-pop.csv", col_types = cols(sal_code = col_character()))
sal_muni_link <- read_csv("sources/sal-muni-link.csv", col_types = cols(muni_code = col_character(), 
                                                                sal_code = col_character()))

sal_pop_est = inner_join(inner_join(sal_pop, sal_muni_link, by = "sal_code"), muni_pop_growth, by = "muni_code") %>%
  mutate(pop_est = pop * factor_rel_2011) %>%
  select(c("sal_code", "muni_code", "year", "pop_est"))

write_csv(sal_pop_est, "sal-estimated-population-per-year.csv")
