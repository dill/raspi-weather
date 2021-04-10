# metcheck
# https://www.metcheck.com/OTHER/json_data.asp
library(httr)
library(lubridate)

options(stringsAsFactors=FALSE)

weather <- GET("http://ws1.metcheck.com/ENGINE/v9_0/json.asp?lat=56.4&lon=-2.9&lid=61257&Fc=No")
weather_dat <- content(weather, type="application/json")
weather_dat <- do.call(rbind.data.frame, weather_dat$metcheckData[[1]]$forecast)

# do some data faff
weather_dat$DateTime <- ymd_hms(weather_dat$utcTime)
# convert to this timezone
weather_dat$DateTime <- with_tz(weather_dat$DateTime, "Europe/London")
# sort
weather_dat <- weather_dat[order(weather_dat$DateTime), ]

# get just the columns we want
weather_dat <- weather_dat[, c("temperature", "windgustspeed", "windletter",
                               "iconName", "weekday", "sunrise", "sunset",
                               "DateTime", "windspeed", "windletter",
                               "windgustspeed")]

weather_dat$temperature <- as.numeric(weather_dat$temperature)
weather_dat$windspeed <- as.numeric(weather_dat$windspeed)
weather_dat$windgustspeed <- as.numeric(weather_dat$windgustspeed)

