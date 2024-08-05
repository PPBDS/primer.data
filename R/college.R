#' @title
#' Integrated Postsecondary Education Data System
#'
#' @description
#' This dataset is from the \href{https://nces.ed.gov/ipeds/}{Integrated Postsecondary Education Data System (IPEDS)},
#' a system of interrelated surveys conducted annually by the National Center for Education Statistics.
#' These surveys have been conducted since 1992 and primarily aims to calculate the
#' contribution of postsecondary education to the gross national product.
#'
#' @details
#' #' The data for the tibble comes from 2013, so the many of the variables could be very very different due to inflation or changes in the educational system.
#' Data comes from IPEDS, but was downloaded from
#' \href{https://opportunityinsights.org/}{Opportunity Insights}
#'
#' @format A tibble with 950 observations and 13 variables:
#' \describe{
#'   \item{name}{character variable for name of college}
#'   \item{region}{factor variable for the region corresponding to college's location ("Northeast", "South", "East", "Midwest")}
#'   \item{state}{character variable for the 2-letter abbreviation of state which college is located in}
#'   \item{county}{character variable for the county which a college is located in}
#'   \item{zip}{integer variable for the zip code of the college}
#'   \item{public}{logical variable for whether or not a school is public}
#'   \item{tier}{integer variable representing the level of prestige & selectivity a college holds (1-6)}
#'   \item{hbcu}{logical varibale representing whether or not the college is a historically black college/university}
#'   \item{enrollment}{integer variable for total undergraduate enrollment (full time + part time) in fall 2013}
#'   \item{tuition}{double variable for the average annual cost of attendance (Tuition + Fees) in 2013 in tens of thousands of dollars}
#'   \item{grad_rate}{double variable for the graduation rate in 2013}
#'   \item{sat}{integer variable for average SAT scores (scaled to 1600) in 2013,
#'   defined as the mean of the 25th and 75th percentile of math+verbal SAT scores.}
#'   \item{selectivity}{ordered factor variable for the overall selectiveness of the college according to Barrons. Has levels
#'   "Elite", "Highly Selective", "Moderately Selective", "Lowly Selective", "Non-selective"}
#' }
#'
#' @author
#' Tanay Janmanchi
#'
#' @source
#' \url{https://opportunityinsights.org/data/}
#'
#'
#'
"colleges"
