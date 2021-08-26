#' @title Philadelphia experiment on mail-in voting
#'
#' @description
#'
#' This data is from a paper entitled
#' \href{https://github.com/PPBDS/primer.data/blob/master/inst/papers/mail.pdf}{Results
#' from a 2020 field experiment encouraging voting by mail}. See also the
#' 'Details' section below. The aim of the study was to understand how
#' facilitating mail ballot requests affects their use. A total of over 935,000
#' registered voters in Philadelphia were randomly assigned to either a control
#' group or one of two treatment groups. The results combine information on
#' voting behavior with voter's demographic background.
#'
#'
#' @details
#'
#' Pennsylvania's primary election took place on 2 June, 2020. Two weeks before
#' the election, on 18 May 2020, a group of randomly selected registrants in
#' Philadelphia received postcards with information about applying to vote by
#' mail. This was the first statewide federal election held since Pennsylvania
#' adopted universal access to mail ballots, so information about how to apply
#' was particularly likely to increase awareness of voting by mail.
#'
#' Registrants were sent one of two postcards about mail ballots or no postcard.
#' The postcards conveyed information about the 26 May deadline to request a
#' mail ballot and included a message either encouraging voters to request a
#' ballot because “it’s safer for you to vote by mail!” or “it’s safer for
#' neighborhood to vote by mail!”. In all, 23,475 registered voters were
#' assigned to the “self” condition and 23,485 to the “neighborhood” condition,
#' with the remaining 888,785 in the control condition receiving no postcard.
#'
#' @format A tibble with 935,707 observations and 11 variables: \describe{
#'   \item{treatment}{character variable indicating which of the 3 treatments
#'   was employed before the 2020 primary election: 'No Postcard', 'Self', or
#'   'Neighborhood'} \item{voted}{character variable for whether respondent
#'   voted} \item{voted_mail}{character variable for whether respondent voted by
#'   mail} \item{applied_mail}{character variable for whether respondent applied
#'   for a mail ballot} \item{applied_date}{date variable for the date that
#'   respondent's mail ballot application was received} \item{voted_date}{date
#'   variable for the date that respondent's mail ballot was received}
#'   \item{party}{character variable for respondent's party registration}
#'   \item{age}{factor variable for respondent's age group} \item{sex}{character
#'   variable for respondent's sex} \item{pred_white}{double variable for
#'   likelihood of respondent being white based on their name}
#'   \item{pred_black}{double variable for likelihood of respondent being black
#'   based on their name} }
#'
#' @author David Kane
#'
#' @source \url{https://doi.org/10.7910/DVN/HUUEGI}
#'
"mail"
