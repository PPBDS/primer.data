#' @title Global monthly temperature deviations (1978-2021)
#'
#' @description
#'
#' This data set is based on research by meteorologists Roy Spencer and John
#' Christy, who use satellite-measured data to calculate global monthly
#' temperature changes. Their results are freely accessible
#' \href{https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt}{here}.
#' The values show monthly temperature deviations in °C for selected regions,
#' relative to the respective 1991-2021 average temperature.
#'
#' @format A tibble with 511 observations and 29 variables:
#' \describe{
#'   \item{year}{integer variable for year of measurement}
#'   \item{month}{integer variable for year of measurement}
#'   \item{globe}{double variable for global average deviation from reference value}
#'   \item{globe_land}{double variable for global average deviation from reference value on land}
#'   \item{globe_ocean}{double variable for global average deviation from reference value on oceans}
#'   \item{nh}{double variable for average deviation from reference value in northern hemisphere}
#'   \item{nh_land}{double variable for average deviation from reference value in northern hemisphere on land}
#'   \item{nh_ocean}{double variable for average deviation from reference value in northern hemisphere on oceans}
#'   \item{sh}{double variable for average deviation from reference value in southern hemisphere}
#'   \item{sh_land}{double variable for average deviation from reference value in southern hemisphere on land}
#'   \item{sh_ocean}{double variable for average deviation from reference value in southern hemisphere on oceans}
#'   \item{tropics}{double variable for average deviation from reference value in tropics}
#'   \item{tropics_land}{double variable for average deviation from reference value in tropics on land}
#'   \item{tropics_ocean}{double variable for average deviation from reference value in tropics on oceans}
#'   \item{north_ext}{double variable for average deviation from reference value in northern extratropics}
#'   \item{north_ext_land}{double variable for average deviation from reference value in northern extratropics on land}
#'   \item{north_ext_ocean}{double variable for average deviation from reference value in northern extratropics on oceans}
#'   \item{south_ext}{double variable for average deviation from reference value in southern extratropics}
#'   \item{south_ext_land}{double variable for average deviation from reference value in southern extratropics on land}
#'   \item{south_ext_ocean}{double variable for average deviation from reference value in southern extratropics on oceans}
#'   \item{north_pole}{double variable for average deviation from reference value on the north pole}
#'   \item{north_pole_land}{double variable for average deviation from reference value on the north pole on land}
#'   \item{north_pole_ocean}{double variable for average deviation from reference value on the north pole on oceans}
#'   \item{south_pole}{double variable for average deviation from reference value on the south pole}
#'   \item{south_pole_land}{double variable for average deviation from reference value on the south pole on land}
#'   \item{south_pole_ocean}{double variable for average deviation from reference value on the south pole on oceans}
#'   \item{usa48}{double variable for average deviation from reference value in contiguous United States}
#'   \item{usa49}{double variable for average deviation from reference value in contiguous United States and Alaska}
#'   \item{australia}{double variable for average deviation from reference value in Australia}
#'   }
#'
#' @author David Kane
#'
#' @source \url{https://www.nsstc.uah.edu/data/msu/v6.0/tlt/uahncdc_lt_6.0.txt}
#'
"temperature"
