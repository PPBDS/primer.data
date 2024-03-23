#' @title
#' American National Election Studies
#'
#' @description
#' This dataset is from the \href{https://electionstudies.org/}{American National
#' Election Studies (ANES)}, a survey that aims to provide insights into voter
#' behavior. It has been conducted since 1948 before and after each presidential
#' election, and combines questions about voters' political attitudes with extensive
#' biographical information. Current as of September 16, 2022.
#'
#' @details
#' Some of the questions aksed in the survey have changed slightly over time. The
#' \href{https://electionstudies.org/wp-content/uploads/2018/12/anes_timeseries_cdf_codebook_var.pdf}{ANES
#' codebook} provides further information on this issue.
#'
#' @format A tibble with 46,838 observations and 18 variables:
#' \describe{
#'   \item{year}{integer variable for year of study}
#'   \item{state}{character variable for the 2-letter abbreviation of respondent's survey state}
#'   \item{sex}{character variable with values "Male", "Female", and "Other"}
#'   \item{income}{factor variable for respondent's income percentile group. Has levels
#'                 "0 - 16", "17 - 33", "34 - 67", "68 - 95", and "96 - 100"}
#'   \item{age}{factor variable for respondent's age group. Has levels
#'      "17 - 24", "25 - 34", "35 - 44", "45 - 54", "55 - 64", "65 - 74", and "75 +"}
#'   \item{education}{factor variable with a 7 levels measuring highest educational achievement}
#'   \item{race}{character variable for respondent's racial / ethnical identity}
#'   \item{ideology}{factor variable for respondent's party identification with 7 levels}
#'   \item{voted}{character variable indicating whether the respondent voted in the national elections}
#'   \item{region}{factor variable for the region corresponding to respondent's survey state}
#'   \item{pres_appr}{character variable for respondent's self-reported approval of the sitting president.
#'   Question was not asked before 1972}
#'   \item{influence}{character variable for respondent's opinion on the statement "People like
#'   me have any say in what the government does"}
#'   \item{equality}{character variable for respondent's opinion on the statement "Our society
#'   should do whatever is necessary to make sure that everyone has an equal opportunity to succeed".
#'   Question was not asked before 1984}
#'   \item{religion}{character variable for importance of religion in respondent's life. Question was not
#'   asked before 1980}
#'   \item{better_alone}{character variable for respondent's opinion on the statement "This country
#'   would be better off if we just stayed home and did not concern ourselves with problems in other
#'   parts of the world". Question was not asked before 1956}
#'   \item{therm_black}{integer variable for respondent's self-reported attitude toward black people. Takes
#'   "thermometer" values from 0 (very negative) to 100 (very positive). Question was not asked before 1964}
#'   \item{therm_white}{integer variable for respondent's self-reported attitude toward white people. Takes
#'   "thermometer" values from 0 (very negative) to 100 (very positive). Question was not asked before 1964}
#'   \item{pres_vote}{Character variable indicating respondent's vote for Presidential party. Allowed values
#'   are "Democrat", "Republican", or "Third Party". Value of "Third Party" restricted to Wallace in 1968,
#'   Anderson in 1980, Perot in 1992 or 1996, and Jorgensen in 2020}

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
