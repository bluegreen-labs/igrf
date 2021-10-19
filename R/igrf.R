#' International Geomagnetic Reference Field
#'
#' The 13th Generation International Geomagnetic Reference Field.
#'
#' The R model underpinning the base function is the original Fortran
#' model published by Alken et al. 2021 and available on the project
#' website <https://www.ngdc.noaa.gov/IAGA/vmod/igrf.html>.
#'
#' Outputs have been verified to correspond with the original code with
#' the exception that values in the R implementation are not rounded before
#' output (as in the original model). For all intents and purposes the data
#' can be considered equivalent.
#'
#' For full model details I refer Alken et al. 2021, and the project website
#' where both the original code and a brief model description can be found.
#' The authors of both the R package and the original Fortran code
#' take no responsibility regarding the use of these data within
#' a professional context <https://www.ngdc.noaa.gov/IAGA/vmod/igrfhw.html>.
#'
#' @param field main field (default = "main") or secular variation ("variation") data output
#' @param type "spheroid" (default) or "sphere" representation
#' @param year Decimal year between 1900 and 2030 A.D
#' @param latitude latitude in decimal degrees
#' @param longitude longitude in decimal degrees
#' @param altitude in km above the earth surface for a spheroid type,
#'  or distance from the earth center (radial distance) for the sphere
#'  representation (in the later the value should exceed 3485km)
#'
#' @return a data frame with components X,Y,Z,F, D, H and I for the main
#' geomagnetic field or the secular variations, i.e. instantaneous time
#' rate of change of the geomagnetic main field. Keep in mind that the
#' secular variations are generally only used for interpolation purposes
#' and do not reflect the actual rate of change. For more guidance on the
#' use of the secular variations and caveats we refer to the main project's
#' website <https://www.ngdc.noaa.gov/IAGA/vmod/igrfhw.html>.
#'
#' @export
#' @useDynLib igrf
#' @examples
#' field <- igrf::igrf(
#'  field = "main",
#'  year = 2000,
#'  type = "spheroid",
#'  altitude = 2,
#'  latitude = 50,
#'  longitude = 10
#' )

igrf <- function(
  field = "main",
  year,
  type = "spheroid",
  altitude,
  latitude,
  longitude
){

  # degrees-rad
  fact <- 180/3.141592654

  # checks on year values
  if (floor(year) > 2025) {
    warning("
    This version of the IGRF is intended for use up to 2025!
    Values will be computed but may be of reduced accuracy.
    "
    )
  }

  # checks on year values
  if (floor(year) < 1900 || floor(year) > 2030) {
    stop("Dates must fall between 1900 - 2030.!")
  }

  # sanity check type
  if(type != "spheroid" && type != "sphere") {
    stop("Wrong type type (either spheroid or sphere)!")
  }

  # sanity checks on latitude
  if(latitude < -90 || latitude > 90){
    stop("Out of bound latitude!")
  }

  # sanity checks on latitude
  if(longitude < -180 || longitude > 180){
    stop("Out of bound longitude!")
  }

  # calculate colatitude
  colat <- 90 - latitude

  if(type == "spheroid"){
    type <- 1
  } else {

    # check radial distance
    if (altitude <= 3485) {
      stop("Radial distance does not exceed 3485 km, enter a larger value!")
    }

    type <- 2
  }

  # run the model main field (always run)
  df <- .Call("c_igrf13_f",
              as.integer(0),
              as.double(year),
              as.integer(type),
              as.double(altitude),
              as.double(colat),
              as.double(longitude)
  )

  # tag on sensible column names
  df <- as.data.frame(df)
  colnames(df) <- c("X","Y","Z","F")

  # convert values for the main field
  df$D = fact * atan2(df$Y, df$X)
  df$H = sqrt(df$X^2 + df$Y^2)
  df$I = fact * atan2(df$Z, df$H)

  if(field == "variation"){
    # run the model secular variation
    df_s <- .Call("c_igrf13_f",
                  as.integer(1),
                  as.double(year),
                  as.integer(type),
                  as.double(altitude),
                  as.double(colat),
                  as.double(longitude)
    )

    # tag on sensible column names
    df_s <- as.data.frame(df_s)
    colnames(df_s) <- c("dX","dY","dZ","dF")

    # convert values for the secular variations
    df_s$dD = (60*fact*(df$X*df_s$dY - df$Y*df_s$dX))/(df$H^2)
    df_s$dH = (df$X*df_s$dX + df$Y*df_s$dY)/df$H
    df_s$dI = (60*fact*(df$H*df_s$dZ - df$Z*df_s$dH))/(df$F^2)
    df_s$dF = (df$H*df_s$dH + df$Z*df_s$dZ)/df$F

    # combine main field with secular variation data
    df <- cbind(df, df_s)
  }

  # return data
  return(df)
}

.onUnload <- function(libpath) {
  library.dynam.unload("igrf", libpath)
}
