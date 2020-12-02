#' @title
#' Data from the Cooperative Congressional Election Study
#'
#' @description
#' Data for the approval ratings of voters to various government positions
#' combined with the demographic background of the voter. See
#' \href{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/II2DB6}{Kuriwaki
#' (2018)} for background and details. The raw code that was used to produce
#' the data is accesible at Kuriwaki's \href{https://github.com/kuriwaki/cces_cumulative}{Github.}
#'
#' @details
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(cces)
#' ```
#'
#' @format A tibble with 452,755 observations and 16 variables:
#' \describe{
#'   \item{year}{integer variable for year of survey}
#'   \item{state}{character variable for state of residence for observation}
#'   \item{gender}{charcater variable of "Female" and "Male"}
#'   \item{age}{integer variable for age in years}
#'   \item{education}{factor variable for level of education - takes values of "No HS",
#'   "High School Graduate", "Some College", "2-Year", "4-Year", and "Post-Grad"}
#'   \item{race}{character variable for racial identity}
#'   \item{marstat}{character variable for marriage status}
#'   \item{ideology}{factor variable for self-reported ideology - takes values of "Very Liberal",
#'   "Liberal", "Moderate", "Conservative", "Very Conservative", and "Not Sure"}
#'   \item{news}{character variable for level news/current events interest}
#'   \item{econ}{character variable for retrospective report on the past year's economy}
#'   \item{approval_ch}{character variable of approval of president - takes values of
#'   "Strongly Approve", "Approve / Somewhat Approve", "Disapprove / Somewhat Disapprove",
#'   "Never Heard / Not Sure", "Neither Approve Nor Disapprove"}
#'   \item{approval}{numeric variable of approval for the current president on a 1-5 scale
#'    with higher numbers indicating greater approval}
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/II2DB6}
#'
#'
"cces"
