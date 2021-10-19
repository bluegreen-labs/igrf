#' Generate an IGRF regular grid
#'
#' Generates a global grid (map) of the 13th Generation International
#' Geomagnetic Reference Field (IGRF) for a predefined spatial resolution
#' (in decimal degrees).
#'
#' @param field main field (default = "main") or secular variation ("variation") data output
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
#' variation on a regular grid. Data is returned in a tidy format with
#' required latitude and longitude columns for convenient plotting.
#'
#' @export
#' @examples
#' grid <- igrf::igrf_grid(
#' year = 2000,
#' field = "main",
#' type = "spheroid",
#' altitude = 2,
#' resolution = 5
#' )

igrf_grid <- function(
  field = "main",
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
     field,
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
