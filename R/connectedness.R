#' @title US County Economic Connectednesss Data from Opportunity Insights
#'
#' @description Data from [Opportunity
#' Insights](https://opportunityinsights.org/) about economic connectedness
#' across US counties. Connectedness is defined as two times the share of
#' high-SES friends among low-SES individuals, averaged over all low-SES
#' individuals in the county.
#'
#' @format A tibble with 3,089 observations and 3 variables:
#' \describe{
#'   \item{location}{character variable for county and state name}
#'   \item{population}{numeric variable for county population in 2018}
#'   \item{connectedness}{numeric variable measuring economic connectedness}
#' }
#'
#' @author David Kane
#'
#' @source
#' \url{https://data.humdata.org/dataset/social-capital-atlas}
#'
#'
"connectedness"
