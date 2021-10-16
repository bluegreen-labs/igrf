igrf_year <- function(date) {

  # convert to Date format
  date <- as.Date(date)
  year <- as.numeric(format(date, "%Y"))
  doy <- as.numeric(format(date, "%j"))

  # start + end
  year_beginning <- as.Date(paste0(year, '-01-01'))
  year_end <- as.Date(paste0(year, '-12-31'))

  # year length
  year_length <- as.numeric(year_end - year_beginning)

  print(year_length)
  fraction <- doy / year_length

  # decimal date
  date <- year + fraction

  # return converted date
  date
}
