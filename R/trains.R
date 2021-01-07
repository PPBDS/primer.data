#' @title
#' Experimental effects on attitudes toward immigration
#'
#' @description
#' Data for attitudes toward immigration-related policies, both before and after
#' an experiment which randomly exposed a treated group to Spanish-speakers on a
#' Boston commuter train platform. See Enos (2014)
#' for background and details (\href{https://github.com/PPBDS/primer.data/blob/master/inst/papers/trains.pdf}{pdf}).
#' Individuals with a treatment value of "Treated" were exposed to two
#' Spanish-speakers on their regular commute. "Control" individuals were not.
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
#'   \item{treatment}{factor variable with two levels: "Treated" and "Control"}
#'   \item{att_start}{Starting attitude toward immigration issues. Uses a 3 to 15 scale,
#'                    with higher numbers meaning more conservative}
#'   \item{att_end}{Ending attitude toward immigration issues. Uses a 3 to 15 scale,
#'                  with higher numbers meaning more conservative}
#'   \item{gender}{character variable with values "Male" and "Female"}
#'   \item{race}{character variable with values "Asian", "Black", "Hispanic", and "White"}
#'   \item{liberal}{logical variable with TRUE meaning liberal}
#'   \item{party}{character variable with values "Democrat" and "Republican"}
#'   \item{age}{integer variable for age in years}
#'   \item{income}{numeric variable for family income in dollars}
#'   \item{line}{character variable for commuter train line, with values "Framingham" and "Franklin"}
#'   \item{station}{character variable for train station}
#'   \item{hisp_perc}{numeric variable for percentage of Hispanic residents in person's zip code}
#'   \item{ideology_start}{Measure of political ideology, before the experiment, on a 1 to 5 scale,
#'                         with higher numbers meaning more conservative}
#'   \item{ideology_end}{Measure of political ideology, after the experiment, on a 1 to 5 scale,
#'                         with higher numbers meaning more conservative}
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/DOP4UB}
#'
"trains"
