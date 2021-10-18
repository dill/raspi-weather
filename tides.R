# get tides
tides <- function(code){

  # get the page for our beach
  # this is dependent on the BBC not messing around with the page format
  pp <- read_html(paste0("https://www.bbc.co.uk/weather/coast-and-sea/tide-tables/", code))

  # select today ("day-0")
  high_tide <- pp %>%
    # extract data from in the SVG
    html_element(css=".wr-c-tides-today__next__time--high > span:nth-child(1)") %>%
    html_text2() %>%
    str_extract("\\d{2}:\\d{2}")
  low_tide <- pp %>%
    # extract data from in the SVG
    html_element(css=".wr-c-tides-today__next__time--low > span:nth-child(1)") %>%
    html_text2() %>%
    str_extract("\\d{2}:\\d{2}")
  # get just the unique entries
  tide_dat <- data.frame(Tide = c("High", "Low"),
                         Time = c(high_tide, low_tide))

  return(tide_dat)
}
