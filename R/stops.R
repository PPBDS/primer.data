#' @title
#' New Orleans Traffic Stops Data
#'
#' @description
#' This data is from the \href{https://openpolicing.stanford.edu/findings/}{Stanford Open Policing Project},
#' which aims to improve police accountability and transparency by providing data on traffic stops across
#' the United States. The \href{https://openpolicing.stanford.edu/data/#new-orleans}{New Orleans dataset}
#' includes detailed information about traffic stops conducted by the New Orleans Police Department.
#'
#' @details
#' The dataset includes information about the date, time, and location of each stop, as well as demographic
#' details about the driver and the outcomes of the stop. The data covers traffic stops from 2011 to 2017.
#' The purpose of this dataset is to facilitate research on racial disparities in policing practices.
#'
#' @format A tibble with 1,000,000+ observations and 15 variables:
#' \describe{
#' \item{stop_id}{character variable indicating a unique identifier for each stop}
#' \item{date}{date variable indicating the date of the stop}
#' \item{time}{time variable indicating the time of the stop}
#' \item{location}{character variable indicating the location of the stop}
#' \item{subject_race}{character variable indicating the race of the driver}
#' \item{subject_sex}{character variable indicating the sex of the driver}
#' \item{subject_age}{integer variable indicating the age of the driver}
#' \item{officer_id}{character variable indicating a unique identifier for the officer conducting the stop}
#' \item{violation}{character variable indicating the reason for the stop}
#' \item{search_conducted}{logical variable indicating whether a search was conducted}
#' \item{search_type}{character variable indicating the type of search conducted, if any}
#' \item{contraband_found}{logical variable indicating whether contraband was found during the search}
#' \item{stop_outcome}{character variable indicating the outcome of the stop (e.g., citation, warning, arrest)}
#' \item{arrest_reason}{character variable indicating the reason for arrest, if applicable}
#' \item{officer_race}{character variable indicating the race of the officer}
#' }
#'
#' @author
#' Sanaka Dash
#'
#' @source
#' \url{https://openpolicing.stanford.edu/data/}
#'
"stops"
