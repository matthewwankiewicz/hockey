### scrape schedule #####
library(rvest)
library(tidyverse)


## 2020
link <- "https://fixturedownload.com/results/nhl-2020"

stats <- read_html(link) %>% 
  html_table() %>% 
  .[[1]]

stats %>% 
  select(date = Date, home = `Home Team`, away = `Away Team`, Result) %>% 
  mutate(date = lubridate::dmy(substr(date, 1, 10)),
         season = 2020) %>% 
  separate(Result, into = c("home_score", "away_score"), sep = " - ") %>% 
  mutate_at(.vars = c("home_score", "away_score"), as.numeric) -> nhl2020

## 2021
link <- "https://fixturedownload.com/results/nhl-2021"

stats <- read_html(link) %>% 
  html_table() %>% 
  .[[1]]

stats %>% 
  select(date = Date, home = `Home Team`, away = `Away Team`, Result) %>% 
  mutate(date = lubridate::dmy(substr(date, 1, 10)),
         season = 2021) %>% 
  separate(Result, into = c("home_score", "away_score"), sep = " - ") %>% 
  mutate_at(.vars = c("home_score", "away_score"), as.numeric) -> nhl2021

## 2022
link <- "https://fixturedownload.com/results/nhl-2022"

stats <- read_html(link) %>% 
  html_table() %>% 
  .[[1]]

stats %>% 
  select(date = Date, home = `Home Team`, away = `Away Team`, Result) %>% 
  mutate(date = lubridate::dmy(substr(date, 1, 10)),
         season = 2022) %>% 
  separate(Result, into = c("home_score", "away_score"), sep = " - ") %>% 
  mutate_at(.vars = c("home_score", "away_score"), as.numeric) -> nhl2022



## rbind the tables
nhl_tables <- rbind(nhl2020, nhl2021, nhl2022)

nhl_tables <- nhl_tables %>% 
  mutate(home_win = ifelse(home_score > away_score, 1, 0))


### read in stats #####
## 2020
link <- "https://www.naturalstattrick.com/teamtable.php?fromseason=20202021&thruseason=20202021&stype=2&sit=5v5&score=all&rate=n&team=all&loc=B&gpf=410&fd=&td="

read_html(link) %>% 
  html_table() %>% 
  .[[1]] %>% 
  janitor::clean_names() %>% 
  select(-x) %>% 
  mutate(season = 2020) -> stats2020

stats2020[stats2020 == "Montreal Canadiens"] <- "Montréal Canadiens"
stats2020[stats2020 == "St Louis Blues"] <- "St. Louis Blues"

## 2021
link <- "https://www.naturalstattrick.com/teamtable.php?fromseason=20212022&thruseason=20212022&stype=2&sit=5v5&score=all&rate=n&team=all&loc=B&gpf=410&fd=&td="

read_html(link) %>% 
  html_table() %>% 
  .[[1]] %>% 
  janitor::clean_names() %>% 
  select(-x) %>% 
  mutate(season = 2021) -> stats2021

stats2021[stats2021 == "Montreal Canadiens"] <- "Montréal Canadiens"
stats2021[stats2021 == "St Louis Blues"] <- "St. Louis Blues"

## 2022
link <- "https://www.naturalstattrick.com/teamtable.php?fromseason=20222023&thruseason=20222023&stype=2&sit=5v5&score=all&rate=n&team=all&loc=B&gpf=410&fd=&td="

read_html(link) %>% 
  html_table() %>% 
  .[[1]] %>% 
  janitor::clean_names() %>% 
  select(-x) %>% 
  mutate(season = 2022) -> stats2022

stats2022[stats2022 == "Montreal Canadiens"] <- "Montréal Canadiens"
stats2022[stats2022 == "St Louis Blues"] <- "St. Louis Blues"


## merge the stats with the schedules, then rbind the files
## 2020
nhl2020 %>% 
  left_join(stats2020,
            by = c("home" = "team")) %>% 
  left_join(stats2020,
            by = c("away" = "team")) -> nhl2020_stats

## 2021
nhl2021 %>% 
  left_join(stats2021,
            by = c("home" = "team")) %>% 
  left_join(stats2021,
            by = c("away" = "team")) -> nhl2021_stats

## 2022
nhl2022 %>% 
  left_join(stats2022,
            by = c("home" = "team")) %>% 
  left_join(stats2022,
            by = c("away" = "team")) -> nhl2022_stats

## rbind the files
nhl_schedule <- rbind(nhl2020_stats, nhl2021_stats, nhl2022_stats)

nhl_schedule <- nhl_schedule %>% 
  mutate(home_win = ifelse(home_score > away_score, 1, 0)) %>% 
  drop_na(home_win)
