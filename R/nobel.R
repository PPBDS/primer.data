#' @title Data on Nobel Prize laureates
#'
#' @description
#'
#' This data comes from the freely accessible API of the
#' \href{https://www.nobelprize.org/about/developer-zone-2/}{Nobel Foundation}.
#' The data includes  information on all Nobel Prize laureates since 1901, as
#' well as on all laureates in the Nobel Memorial Prize in Economic Sciences
#' since 1968.
#'
#' @format A tibble with 961 observations and 16 variables:
#' \describe{
#'   \item{first_name}{character variable for laureate's first name}
#'   \item{last_name}{character variable for laureate's last name}
#'   \item{year}{interger variable for year in which the price was awarded}
#'   \item{field}{factor variable for field in which the price was awarded}
#'   \item{share}{integer variable for number of laureates who shared the price}
#'   \item{gender}{factor variable for laureate's gender}
#'   \item{born}{date variable for laureate's birth date}
#'   \item{died}{date variable for laureate's death date}
#'   \item{born_country}{character variable for laureate's country of birth at the time}
#'   \item{born_city}{character variable for laureate's city of birth at the time}
#'   \item{died_country}{character variable for laureate's country of death at the time}
#'   \item{died_city}{character variable for laureate's city of death at the time}
#'   \item{motivation}{character variable for reason of award}
#'   \item{aff_inst}{character variable for laureate's academic affiliation}
#'   \item{aff_city}{character variable for city of institution of laureate's academic affiliation}
#'   \item{aff_country}{character variable for country of institution of laureate's academic affiliation}
#'   }
#'
#' @author David Kane
#'
#' @source \url{https://www.nobelprize.org/about/developer-zone-2/}
#'
"nobel"
