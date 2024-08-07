#' @title New Orleans Traffic Stops Data
#'
#' @description This data is from the
#' \href{https://openpolicing.stanford.edu/findings/}{Stanford Open Policing
#' Project}, which aims to improve police accountability and transparency by
#'   providing data on traffic stops across the United States. The
#' \href{https://openpolicing.stanford.edu/data/#new-orleans}{New Orleans
#' dataset} includes detailed information about traffic stops conducted by the
#'   New Orleans Police Department.
#'
#' @details The dataset includes information about the date, time, and location
#'   of each stop, as well as demographic details about the driver and the
#'   outcomes of the stop. The data covers traffic stops from July 1, 2011 to
#'   July 18, 2018. Any records with missing values were deleted. This might
#'   cause some issues because stops which resulted in an arrest were 4 times
#'   more likely to feature a missing value for 'age'.
#'
#' @format A tibble with about 400,000 observations and 7 variables:
#' \describe{
#' \item{date}{date variable indicating the date of the stop}
#' \item{time}{time variable indicating the time of the stop}
#' \item{zone}{character variable indicating the zone of the officer conducting
#' the stop}
#' \item{race}{character variable indicating the race of the driver}
#' \item{sex}{character variable indicating the sex of the driver}
#' \item{age}{integer variable indicating the age of the driver}
#' \item{arrested}{character variable indicating whether an arrest was made}
#' }
#'
#' @author Sanaka Dash
#'
#' @source \url{https://openpolicing.stanford.edu/data/}
#'
"stops"
