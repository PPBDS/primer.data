#' @title People shot by US police (2015-2019)
#'
#' @description
#'
#' This data comes from the book \href{https://crimebythenumbers.com}{Crime by
#' the Numbers: A Criminologist’s Guide to R}, which compiles multiple data sets from
#' the FBI Uniform Crime Report. Variables included here contain information
#' on shooting victims of US police between 2015 and 2019.
#'
#' @format A tibble with 4371 observations and 13 variables:
#' \describe{
#'   \item{name}{character variable for name of shooting victim}
#'   \item{date}{date variable for date of shooting}
#'   \item{state}{character variable for state in which shooting took place}
#'   \item{city}{character variable for city in which shooting took place}
#'   \item{manner_of_death}{character variable for manner of death}
#'   \item{weapon}{character variable for weapon used by shooting victim}
#'   \item{age}{integer variable for age of shooting victim}
#'   \item{gender}{character variable for gender of shooting victim}
#'   \item{race}{character variable for race of shootings victim}
#'   \item{mental_illness_signs}{character variable indicating whether shooting victim showed signs of mental illness}
#'   \item{threat_level}{character level for tyoe of threat posed by shooting victim}
#'   \item{flee}{character variable indicating whether shooting victim tried to flee}
#'   \item{body_camera}{character variable indicating whether police officer involved carried a body camera}
#'   }
#'
#' @author David Kane
#'
#' @source \url{https://github.com/jacobkap/crimebythenumbers/blob/master/data/shootings.csv}
#'
"shootings"
