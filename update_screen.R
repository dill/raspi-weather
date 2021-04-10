# update the screen


library(reticulate)
library(lubridate)
library(lunar)

options(stringsAsFactors=FALSE)
source("metcheck.R")
source("tides.R")

weather_dat <- weather_dat[weather_dat$DateTime < (now()+hours(24)), ]

sunrise <- weather_dat$sunrise[1]
sunset <- weather_dat$sunset[1]

# temperatures
hightemp <- paste0(max(weather_dat$temperature), "C")
lowtemp <- paste0(min(weather_dat$temperature), "C")

# wind speed (convert to km/h)
wind <- paste0(round(1.60934 * max(weather_dat$windspeed), 0), " ",
               weather_dat$windletter[which.max(weather_dat$windspeed)])
gust <- paste0(round(1.60934 * max(weather_dat$windgustspeed), 0))

# we have up arrows, for low tide rotate them
tide_status <- rep(0, nrow(tide_dat))
tide_status[tide_dat$Tide=="Low"] <- 180
# tide height is in metres
tide_height <- paste0(tide_dat$Height, "m")

# get the weather icon
weather_csv <- read.csv("weather_codes.csv", header=FALSE)
icon_ind <- which(weather_dat$iconName[1] == weather_csv[, 1])
ico_path <- sub(" ", "", weather_csv[icon_ind, 2])

# get the moon icon
moon_csv <- read.csv("moon_codes.csv", header=FALSE)
moon_icon_ind <- which(as.character(lunar.phase(Sys.Date(), name=8)) ==
                       moon_csv[,1])
moon_ico_path <- sub(" ", "icons/moon_phases/", moon_csv[moon_icon_ind, 2])



today_date <- format(Sys.Date(), "%A %d %B")

source_python("update_rot.py")

display_weather(today_date, sunrise, sunset, hightemp, lowtemp, ico_path,
                tide_status, tide_height, tide_dat$Time, moon_ico_path,
                wind, gust)


