# update the screen


library(reticulate)
library(lubridate)
library(lunar)
library(httr)
library(lubridate)
library(rvest)
library(magrittr)
library(stringr)



options(stringsAsFactors=FALSE)

# source functions to get weather and tide data
source("metcheck.R")
source("tides.R")

weather_dat <- metcheck(lat=56.4, lon=-2.9)
weather_dat <- weather_dat[weather_dat$DateTime < (now()+hours(24)), ]

sunrise <- weather_dat$sunrise[1]
sunset <- weather_dat$sunset[1]

# temperatures
hightemp <- paste0(max(weather_dat$temperature), "C")
lowtemp <- paste0(min(weather_dat$temperature), "C")

# temperature plot
#plot(weather_dat[,c("DateTime","temperature")], axes=FALSE)
#axis(1, at=)
library(ggplot2)
p <- ggplot(weather_dat) +
  geom_line(aes(x=DateTime, y=temperature), size=.3) +
  scale_x_datetime(expand=c(0,0,0,0), date_labels="%H")+
  scale_y_continuous(breaks=seq(min(round(weather_dat$temperature)),
                                max(round(weather_dat$temperature)),1)) +
  theme_minimal() +
  theme(panel.grid=element_blank(),
        plot.margin=grid::unit(c(0.25,0,0,0), "mm"),
        axis.title=element_blank(),
        axis.text.y=element_text(margin=margin(r=-2), size=3),
        axis.text.x=element_text(vjust=8, size=3))
ggsave(p, file="Rtmp/temp.png", units="px", width=260, height=100)


# wind speed (convert to km/h)
wind <- paste0(round(1.60934 * max(weather_dat$windspeed), 0), " ",
               weather_dat$windletter[which.max(weather_dat$windspeed)])
gust <- paste0(round(1.60934 * max(weather_dat$windgustspeed), 0))

# tides
# code here from BBC website: https://www.bbc.co.uk/weather/coast-and-sea/tide-tables
tide_dat <- tides("7/235")
# we have up arrows, for low tide rotate them
tide_status <- rep(0, nrow(tide_dat))
tide_status[tide_dat$Tide=="Low"] <- 180
# tide height is in metres
#tide_height <- paste0(tide_dat$Height, "m")

# get the weather icon
weather_csv <- read.csv("weather_codes.csv", header=FALSE)
icon_ind <- which(weather_dat$iconName[1] == weather_csv[, 1])
ico_path <- sub(" ", "", weather_csv[icon_ind, 2])

# get the moon icon
moon_csv <- read.csv("moon_codes.csv", header=FALSE)
moon_icon_ind <- which(as.character(lunar.phase(Sys.Date(), name=8)) ==
                       moon_csv[,1])
moon_ico_path <- sub(" ", "icons/moon_phases/", moon_csv[moon_icon_ind, 2])


# get the date to show
today_date <- format(Sys.Date(), "%A %d %B")

# update the device
source_python("update_rot.py")
# debug mode
# comment above and uncomment below
#source_python("update_img.py")

# run the reticulated code
display_weather(today_date, sunrise, sunset, hightemp, lowtemp, ico_path,
                tide_status, 0, tide_dat$Time, moon_ico_path,
                wind, gust)


