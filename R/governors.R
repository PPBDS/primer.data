#' @title
#' Election results and longevity of politicians
#'
#' @description
#' This is a dataset corresponding to the paper "Longevity Returns to Political
#' Office" by \href{https://doi.org/10.1017/psrm.2019.63}{Barfort, Klemmensen &
#' Larsen (2019)}. The purpose of this study was to find out whether and how
#' winning an election influences the lifespan of politicians. To answer this
#' question, the authors collected data on all U.S. gubernatorial elections from
#' 1945 to 2012. In addition to the names and votes of the running candidates, the
#' data includes information on their pre- and post-election life spans. See also the
#' 'Details' section below.
#'
#' @details
#' To facilitate subsequent analysis, the raw data collected by the authors was
#' edited in three ways. First, for a given election, only the two candidates who
#' received the highest number of votes were included. Second, candidates with unknown
#' dates of death were excluded, resulting in fewer observations for elections in
#' recent years. Third, in a few instances, only the year of birth or death could
#' be determined; in these cases, the date was taken to be July 1 of that year.
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(governors)
#' ```
#'
#' @format A tibble with 1,092 observations and 11 variables:
#' \describe{
#'   \item{state}{character variable indicating the state in which an election took place}
#'   \item{year}{integer variable indicating the year in which an election took place}
#'   \item{first_name}{character variable indicating the first name of a candidate}
#'   \item{last_name}{character variable indicating the last name of a candidate}
#'   \item{party}{character variable indicating a member's party}
#'   \item{sex}{character variable indicating a member's sex}
#'   \item{died}{date variable indicating the candidate's date of death}
#'   \item{status}{character variable indicating whether a candidate was the challenger or incumbent}
#'   \item{win_margin}{double variable indicating the percentage margin by which the election was won
#'                     (positive values) or lost (negative values)}
#'   \item{alive_post}{integer variable indicating the number of days a candidate lived after
#'                     the election took place}
#'   \item{alive_pre}{integer variable indicating the number of days a candidate lived before
#'                    the election took place}
#
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://doi.org/10.7910/DVN/IBKYRX}
#'
"governors"
