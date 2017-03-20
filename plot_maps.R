library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
library(dplyr)

dat <- read.csv("STWURy.csv")

summaries_city <- group_by(dat, country, region, city) %>% 
  summarise(sessions = sum(sessions),
            users = sum(users),
            newUsers = sum(newUsers))

summaries_country <- group_by(dat, country) %>% 
  summarise(sessions = sum(sessions),
            users = sum(users),
            newUsers = sum(newUsers)) %>% 
  rename(region = country)

map_data <- merge(summaries_country, map_data("world"), by = 'region')

ggplot(data = map_data, aes(x = long, y = lat, group = group)) + 
  geom_polygon() +
  coord_map()
