#' 2020 Census Data for All U.S. Counties
#'
#' A dataset containing demographic information by county for all counties in the
#' United States from the 2020 Decennial Census. This dataset includes population 
#' counts by race and ethnicity for each of the 3,143 counties and county-equivalents
#' in the United States, including Washington D.C. and territories.
#'
#' @format A data frame with 8 variables and counties as rows:
#' \describe{
#'   \item{name}{County name and state (e.g., "Los Angeles County, California") (character)}
#'   \item{total_pop}{Total population count (integer)}
#'   \item{white}{Population identifying as White alone (integer)}
#'   \item{black}{Population identifying as Black or African American alone (integer)}
#'   \item{native_american}{Population identifying as American Indian and Alaska Native alone (integer)}
#'   \item{asian}{Population identifying as Asian alone (integer)}
#'   \item{pacific_islander}{Population identifying as Native Hawaiian and Other Pacific Islander alone (integer)}
#'   \item{hispanic_latino}{Population identifying as Hispanic or Latino of any race (integer)}
#' }
#'
#' @details
#' The data comes from the 2020 Decennial Census Summary File 1 (SF1) tables:
#' \itemize{
#'   \item P1_001N: Total population
#'   \item P1_003N: White alone
#'   \item P1_004N: Black or African American alone
#'   \item P1_005N: American Indian and Alaska Native alone
#'   \item P1_006N: Asian alone
#'   \item P1_007N: Native Hawaiian and Other Pacific Islander alone
#'   \item P2_002N: Hispanic or Latino (of any race)
#' }
#'
#' Note that Hispanic/Latino is an ethnicity category that can apply to individuals
#' of any race, so these counts may overlap with the race-specific categories.
#' 
#' The dataset includes all counties in the 50 states, Washington D.C., and U.S. 
#' territories (Puerto Rico, U.S. Virgin Islands, American Samoa, Guam, and 
#' Northern Mariana Islands).
#'
#' @source U.S. Census Bureau, 2020 Decennial Census, Summary File 1
#'   Retrieved via the tidycensus R package from the U.S. Census Bureau API.
#'
"census"