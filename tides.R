# get tides

library(rvest)
library(magrittr)
library(lubridate)
library(stringr)

# get the page for our beach
# this is dependent on the metoffice not messing around with 
pp <- read_html("https://www.metoffice.gov.uk/weather/specialist-forecasts/coast-and-sea/beach-forecast-and-tide-times/gfn0b1fpm")

# select today ("day-0")
tide_dat <- html_nodes(pp, "#tide-day-0") %>%
  # extract data from in the SVG
  html_nodes("svg") %>%
  html_attr("aria-label")
# get just the unique entries
tide_dat <- unique(tide_dat)

# remvoe "Tide height" and "Tide time"
tide_dat <- tide_dat[!tide_dat %in% c("Tide height", "Tide time")]
# now just process the remaining bits
tide_dat <- str_split(tide_dat, " tide of ")
tide_dat <- unlist(str_split(unlist(tide_dat), " metres at "))

tide_dat <- matrix(tide_dat, ncol=3, byrow=TRUE)
# remove trailing period
tide_dat[,3] <- str_replace(tide_dat[,3], "\\.", "")

tide_dat <- as.data.frame(tide_dat)
colnames(tide_dat) <- c("Tide", "Height", "Time")

