#' @title
#' Student course evaluations from Harvard
#'
#' @description
#' Data for student feedback on Harvard courses. After each semester, the office
#' of the Registrar at Harvard sends all students the
#' \href{https://q.fas.harvard.edu/}{so-called Q Guide}, where students submit
#' both quantitative and qualitative data about their courses. The primary
#' observations of our data set are the overall rating of the course, as well as
#' the workload.
#'
#' @details
#' The data source — skimmed from the Q Guide web app — does not support data
#' for courses that are primarily taught in individual sections. As such, large
#' courses like freshman Expository Writing (taught in 15-person sections) do
#' not have data available. The data set has also been filtered to only include
#' courses with more than 15 registered students.
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(qscores)
#' ```
#'
#' @format A tibble with 748 observations and 8 variables:
#' \describe{
#'   \item{name}{character variable with name of course}
#'   \item{department}{character variable with course department}
#'   \item{number}{character variable with course number}
#'   \item{term}{character variable with values "2018-Fall" and "2019-Spring"}
#'   \item{enrollment}{integer variable with course enrollment}
#'   \item{hours}{numeric variable representing hours per week of workload, outside of class time}
#'   \item{rating}{numeric variable representing average of students' rating of course
#'            (1 to 5 scale), with higher numbers indicating a higher rating}
#'   \item{instructor}{character variable with name of instructor}
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' The data for this tibble was generously provided by Aurash Vatan '23.
#'
"qscores"

