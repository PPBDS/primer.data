#' @title
#' Experimental effects on attitudes toward immigration
#'
#' @description
#' Data for attitudes toward immigration-related policies, both before and after
#' an experiment which randomly exposed a treated group to Spanish-speakers on a
#' Boston commuter train platform. See
#' \href{https://scholar.harvard.edu/files/renos/files/enostrains.pdf}{Enos
#' (2016)} for background and details. Individuals with a treatment value of
#' "Treated" were exposed to two Spanish-speakers on their regular commute.
#' "Control" individuals were not.
#'
#' @details
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(trains)
#' ```
#'
#' @format A tibble with 115 observations and 8 variables:
#' \describe{
#'   \item{gender}{character variable with values "Male" and "Female"}
#'   \item{liberal}{logical variable with TRUE meaning liberal}
#'   \item{party}{character variable with values "Democrat" and "Republican"}
#'   \item{age}{integer variable for age in years}
#'   \item{income}{numeric variable for family income in dollars}
#'   \item{treatment}{factor variable with two levels: "Treated" and "Control"}
#'   \item{att_start}{Starting attitude toward immigration issues. Uses a 3 to 15 scale,
#'                    with higher numbers meaning more conservative}
#'   \item{att_end}{Ending attitude toward immigration issues. Uses a 3 to 15 scale,
#'                  with higher numbers meaning more conservative}
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DOP4UB}
#'
"trains"
