#' @title
#' National Health and Nutrition Examination Survey
#'
#' @description
#' The \href{https://www.cdc.gov/nchs/nhanes/index.htm}{National Health and Nutrition
#' Examination Survey} (NHANES) is a research survey distributed to adults and children
#' across the United States to examine health and nutritional status nationwide. It is
#' unique in that it conducts both interviews and physical examination to produce their data.
#' The survey is run by the National Center for Health Statistics (NCHS), a part of the
#' Centers for Disease Control and Prevention.
#'
#' @details
#' In order to get a demographically diverse range of responses, minority groups were surveyed
#' more heavily. However, this skewed the survey results to have an inaccurate demographic makeup.
#' To address this, some observations of more common groups are resampled in the data.
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(nhanes)
#' ```
#'
#' @format A tibble with 10,000 observations and 15 variables:
#' \describe{
#'   \item{gender}{character variable with values "Male" and "Female"}
#'   \item{survey}{integer variable with the year the survey was conducted in. Most tests were
#'                      conducted across two years, so the earlier year is used.}
#'   \item{age}{character variable for age in years}
#'   \item{race}{character variable with values "White", "Black", "Hispanic", "Mexican", and "Other"}
#'   \item{education}{ordered factor variable with levels "Middle school" < "High school" < "Some college" < "College"}
#'   \item{hh_income}{ordered factor variable for household income groups with levels "0-4999" < [...] < "over 99999"}
#'   \item{weight}{double variable for weight in kilograms}
#'   \item{height}{double variable for height in centimeters}
#'   \item{bmi}{double variable for body mass index}
#'   \item{pulse}{integer variable for pulse in beats per minute or bpm}
#'   \item{diabetes}{integer variable with values 0/1 indicating whether patient suffers from diabetes}
#'   \item{general_health}{integer variable for general health ranked from 1-5. 1 maps to "poor", 2 is "fair", 3 is "good", 4 is "very good", and 5 is "excellent".}
#'   \item{depressed}{character variable answering question how often patient feels depressed.
#'                    Includes values "Several", "None", "Most"}
#'   \item{pregnancies}{integer variable for number of pregnanices.
#'                      NA if the individual, regardless of gender, hasn't experienced a pregnancy}
#'   \item{sleep_night_hrs}{integer value for hours of sleep per night on average}
#'
#' }
#'
#' @author
#' David Kane
#'
#' @source
#' \url{https://cran.r-project.org/web/packages/NHANES/NHANES.pdf}
#'
"nhanes"
