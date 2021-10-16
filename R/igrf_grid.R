#' Generate an IGRF regular grid
#'
#' Generates a global grid (map) of the 13th Generation International
#' Geomagnetic Reference Field (IGRF) for a predefined spatial resolution
#' in decimal degrees.
#'
#' @param isv main field (default = 0) or secular variation (1) data output
#' @param type "spheroid" (default) or "sphere" representation
#' @param year year A.D. Must be greater than or equal to 1900.0 and
#'  less than or equal to 2030. Warning message is given for dates
#'  greater than 2025.
#' @param altitude in km above the earth surface for a geodetic type,
#'  or distance from the earth center for the spherical representation.
#' @param resolution spatial resolution of the output map in decimal degree
#'  (default = 5).
#' @return a data frame with components X,Y,Z,F, D, H and I for the main
#' geomagnetic field or the delta (dX etc) variants for the secular
#' variation with:
#' X = north component (nT) if isv = 0, nT/year if isv = 1
#' Y = east component (nT) if isv = 0, nT/year if isv = 1
#' Z = vertical component (nT) if isv = 0, nT/year if isv = 1
#' F = total intensity (nT) if isv = 0, rubbish if isv = 1
#'
#' Reference:
#' International Geomagnetic Reference Field: the 13th generation
#' Alken, P., Thebault, E., Beggan, C.D. et al. International Geomagnetic
#' Reference Field: the thirteenth generation. Earth Planets Space 73, 49 (2021).
#' <https://doi.org/10.1186/s40623-020-01288-x>
#'
#' @export

igrf_grid <- function(
  isv = 0,
  year,
  type = "spheroid",
  altitude,
  resolution = 5
) {

  # create a grid
  x <- seq(-180, 180, resolution)
  y <- seq(-90, 90, resolution)
  grid <- expand.grid(x,y)
  colnames(grid) <- c("lon","lat")

  # loop over the whole grid to create
  # a field map
  field <- apply(grid, 1, function(x){
    igrf::igrf(
     isv,
     year,
     type,
     altitude,
     latitude = x["lat"],
     longitude = x["lon"]
    )
  })

  # bind the output in one big matrix
  field <- do.call("rbind", field)

  # bind the original coordinates to the output
  field <- cbind(grid, field)

  # return the field
  return(field)
}
