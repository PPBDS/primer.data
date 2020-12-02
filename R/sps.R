#' @title
#' Public health experiment in Mexico
#'
#' @description
#' Data for a randomized assessment of the Mexican universal health insurance
#' programme, both before and after a study which randomly assigned
#' treatment within 74 matched pairs of health clusters --- representing 118,569
#' households in seven Mexican states. See
#' \href{https://gking.harvard.edu/files/gking/files/pubpolforpoor.pdf}{King et
#' al. (2009)} for background and details. Data includes variables from a 2005 baseline
#' survey (August, 2005, to September, 2005) and follow-up survey 10 months
#' later (July, 2006, to August, 2006).
#'
#' @details
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(sps)
#' ```
#'
#'
#' @format A tibble with 27,569 observations and 8 variables:
#' \describe{
#'   \item{age}{integer variable with raw age values of respondents}
#'   \item{sex}{character variable with values "male" and "female"}
#'   \item{educ}{character variable with values "preschool", "primary",
#'   "secondary", "high school", "normal", "technical",
#'   "college", and "post-grad"}
#'   \item{treatment}{binary factor variable for treatment (1) and control (0)}
#'   \item{health_exp_m3}{double variable for health-related expenses in the
#'   last 3 month in pesos}
#'   \item{health_exp_m1}{double variable for
#'   health-related expenses in the last month in pesos}
#'   \item{t2_health_exp_m1}{}
#'   \item{t2_health_exp_m3}{}
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/P6NC0M}
#'
"sps"
