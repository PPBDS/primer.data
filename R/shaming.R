#' @title Michigan voting experiment with social shaming
#'
#' @description This is a data set corresponding to the paper "Social Pressure
#' and Voter Turnout: Evidence from a Large-Scale Field Experiment" by
#' \href{https://doi.org/10.1017/S000305540808009X}{Gerber, Green, and Larimer
#' (2008)}. See also the 'Details' section below. The aim of the study was to
#' find out whether and to what extent people are motivated to vote by social
#' pressure. To answer this question, the authors conducted a field experiment
#' prior to the August 2006 primary election in Michigan. A total of 180,000
#' households were randomly assigned to either a control group or one of four
#' treatment groups.
#'
#' @details The control group consisted of approximately 100,000 households and
#' was observed without further intervention. The value for `treatment` for such
#' households is "No Postcard". The treatment groups consisted of about 20,000
#' households each, and were sent one mailing 11 days prior to the primary
#' election. The first treatment group, named “Civic Duty”, received a letter
#' that only reminded them to "do their civic duty and vote". The second
#' treatment group, named "Hawthorne", received the same message with an
#' additional notice that they are being studied by researchers. The letter sent
#' to the third group, named "Self", included the content in the Hawthorne
#' letter, but added a notice that every household member would be notified of
#' each others' voting behavior after the election (this information is public).
#' The last group, "Neighbors", finally listed not only the household's voting
#' records but also the voting records of those nearby. As in the "Self" group,
#' everyone on the list would be notified of their voting behavior after the
#' primary.
#'
#' @format A tibble with 344,084 observations and 13 variables:
#' \describe{
#'   \item{cluster}{character variable with cluster designation, which ranges from 1 to 10,000. See
#'                   the documentation for extensive discussion about the clustering procedure}
#'   \item{primary_06}{0/1 integer variable indicating whether the respondent voted in the 2006 primary election}
#'   \item{treatment}{factor variable indicating which of the 5 treatments was employed in 2006, but
#'                     before the primary election that year: 'No Postcard', 'Civic Duty', 'Hawthorne',
#'                     'Self', or 'Neighbors'}
#'   \item{sex}{character variable with values "Male" and "Female"}
#'   \item{age}{integer variable indicating the respondent's age in 2006}
#'   \item{primary_00}{0/1 integer variable indicating whether the respondent voted in the 2000 primary election}
#'   \item{general_00}{0/1 integer variable indicating whether the respondent voted in the 2000 general election}
#'   \item{primary_02}{0/1 integer variable indicating whether the respondent voted in the 2002 primary election}
#'   \item{general_02}{0/1 integer variable indicating whether the respondent voted in the 2002 general election}
#'   \item{primary_04}{0/1 integer variable indicating whether the respondent voted in the 2004 primary election}
#'   \item{general_04}{0/1 integer variable indicating whether the respondent voted in the 2004 general election.
#'   Value is always 1 because the sample was determined by looking only at voters in this election}
#'   \item{hh_size}{integer variable indicating the respondent's household size}
#'   \item{neighbors}{integer variable indicating the number of neighbors. This is, presumably, most relevant if the
#'                      respondent was in the "Neighbors" group. neighbors is, in that case, the number of names
#'                      listed on the mailing. Large majority of values is 21, which is the maximum
#'                      number of names which could be printed on the mailing}
#' }
#'
#' @author David Kane
#'
#' @source \url{https://doi.org/10.1017/S000305540808009X}
#'
"shaming"
