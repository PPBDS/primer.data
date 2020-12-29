#' @title
#' American National Election Studies
#'
#' @description
#' This dataset is from the \href{https://electionstudies.org/}{American National
#' Election Studies (ANES)}, a survey that aims to provide insights into voter
#' behavior. It has been conducted since 1948 before and after each presidential
#' election, and combines questions about voters' political attitudes with extensive
#' biographical information. Current as of 07/29/2020.
#'
#' @details
#' Some of the questions aksed in the survey have changed slightly over time. The
#' \href{https://electionstudies.org/wp-content/uploads/2018/12/anes_timeseries_cdf_codebook_var.pdf}{ANES
#' codebook} provides further information on this issue.
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(nes)
#' ```
#'
#' @format A tibble with 38,558 observations and 10 variables:
#' \describe{
#'   \item{year}{integer variable for year of study}
#'   \item{state}{character variable for the 2-letter abbreviation of the state of the interview of a respondent}
#'   \item{gender}{character variable with values "Male", "Female", and "Other"}
#'   \item{income}{factor variable for respondents' income percentile group. Has 5 levels:
#'                 0-16th percentile, 17-33rd, 34-67th, 68-95th, 96-100th}
#'   \item{age}{factor variable of respondents' age ranges, 75+ is accurate except for year 1954}
#'   \item{education}{factor variable with a 7 levels measuring educational achievement}
#'   \item{race}{character variable for respondants' race / ethnicity identification}
#'   \item{ideology}{factor variable for party identification with 7 levels}
#'   \item{pres_appr}{character variable of respondents' self-reported approval of the sitting president. Question
#'                    was not asked before 1972}
#'   \item{voted}{character variable indicating whether the respondent voted in the national elections}
#'   \item{region}{factor variable indicating the region corresponding to the voter's survey state}
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://electionstudies.org/data-center/anes-time-series-cumulative-data-file/}
#'
#'
#'
"nes"
