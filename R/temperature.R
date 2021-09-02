#' @title Global monthly temperature deviations (1978-2021)
#'
#' @description
#'
#' This data set is based on research by meteorologists Roy Spencer and John
#' Christy, who use satellite-measured data to calculate global monthly
#' temperature changes. Their results are freely accessible
#' \href{https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt}{here}.
#' The values show monthly temperature deviations in °C for selected regions,
#' relative to the respective 1991-2021 average temperature.
#'
#' @format A tibble with 511 observations and 29 variables:
#' \describe{
#'   \item{date}{first day of relevant month}
#'   \item{area}{region of the world include the "globe" as a whole, the Northern Hemisphere (nh),
#'               the tropics, the poles and so on. "ext" refers to the region between the tropics
#'               and the poles. usa49 is the continental US, including Alaska but not Hawaii.}
#'   \item{temperature}{average deviation from reference temperature}
#'   }
#'
#' @author David Kane
#'
#' @source \url{https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt}
#'
"temperature"
