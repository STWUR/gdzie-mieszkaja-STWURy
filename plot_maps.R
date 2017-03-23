library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)
library(reshape2)

dat <- read.csv("STWURy.csv")

summaries_city <- group_by(dat, country, region, city) %>% 
  summarise(sessions = sum(sessions),
            users = sum(users),
            newUsers = sum(newUsers))

summaries_country <- group_by(dat, country) %>% 
  summarise(sessions = sum(sessions),
            users = sum(users),
            newUsers = sum(newUsers)) %>% 
  mutate(region = factor(country, labels = c("Denmark", "Finland", "Germany", "Iceland", 
                                             "Ireland", "Italy", "Netherlands", "Norway", 
                                             "Poland", "Slovenia", "Spain", "Sweden", 
                                             "Switzerland", "UK", "USA"))) %>% 
  select(-country)

world_map <- map_data("world")

other_countries <- unique(world_map[["region"]])[!(unique(world_map[["region"]]) %in% summaries_country[["region"]])]

country_full <- rbind(summaries_country, 
                  data.frame(sessions = 0,
                             users = 0,
                             newUsers = 0,
                             region = other_countries)) %>% 
  mutate(sessionsF = cut(sessions, c(0, 1, 3, 40, 650), include.lowest = TRUE))

ggplot(country_full, aes(map_id = region)) + 
  geom_map(aes(fill = newUsers), map = world_map) +
  expand_limits(x = world_map$long, y = world_map$lat) +
  theme_bw()

ggplot(country_full, aes(map_id = region)) + 
  geom_map(aes(fill = sessionsF), map = world_map) +
  expand_limits(x = c(-10, 35), y = c(35, 70)) +
  theme_bw() 

library(RColorBrewer)
ggplot(country_full, aes(map_id = region)) + 
  geom_map(aes(fill = sessionsF), map = world_map) +
  expand_limits(x = c(-10, 35), y = c(35, 70)) +
  theme_bw() +
  scale_fill_manual(values = brewer.pal(4, "GnBu"))

