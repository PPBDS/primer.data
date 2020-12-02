#' @title
#' DW-Nominate data for US Congressional ideological ratings
#'
#' @description
#' This dataset is from \href{https://voteview.com/}{Voteview}, a website by political
#' scientists Keith Poole and Howard Rosenthal that freely provides information on
#' congressional roll call votes in the United States. The data goes back to the first
#' U.S. congress in 1789, and includes votes from both the Senate and the House of
#' Representatives. In addition the the votes themselves, Voteview's datasets include
#' indicators of politicians' ideological positions, which have been estimated using
#' \href{https://en.wikipedia.org/wiki/NOMINATE_(scaling_method)}{NOMINATE}. See also the
#' 'Details' section below.
#'
#' @details
#' At its core, NOMINATE is a scaling procedure that uses algorithms to arrange politicians
#' in a two-dimensional coordinate system based on their voting behaviour and how they compare
#' to others. The x-axis indicates politicians' positions on ideological matters, and
#' the y-axis indicates positions on societal issues, thereby 'mapping' legislatures. For a
#' detailed explanation of the technical background, see the original paper
#' \href{http://dx.doi.org/10.2307/2111172}{"A Spatial Model for Legislative Roll Call Analysis"}
#' by Poole and Rosenthal (1983).
#'
#' &nbsp;
#'
#' ```{r, echo = FALSE}
#' skimr::skim(nominate)
#' ```
#'
#' @format A tibble with 49,361 observations and 9 variables:
#' \describe{
#'   \item{congress}{integer variable indicating the number of a member's congress,
#'                       e.g. 116 for the 116th congress (2019-2021)}
#'   \item{chamber}{character variable indicating the chamber in which a member served}
#'   \item{state}{character variable indicating the state a member represented}
#'   \item{party}{character variable indicating a member's party}
#'   \item{name}{character variable in the format "last, first" indicating a member's name}
#'   \item{born}{double variable indicating a member's year of birth}
#'   \item{died}{double variable indicating a member's year of death}
#'   \item{nominate_dim1}{double variable in the range of \[-1,1] indicating a member's ideological position on
#'                        economic matters, also referred to as the 'left-right' spectrum. Lower values indicate
#'                        left-wing positions, higher values indicate right-wing positions.}
#'   \item{nominate_dim2}{double variable in the range of \[-1,1] indicating a member's ideological position on societal
#'                        matters, e.g. LBGT rights or slavery. Lower values indicate anti-establishment positions,
#'                         higher values indicate pro-establishment positions.}
#
#' }
#'
#' @author
#' David Kane
#'
#' @source \url{https://voteview.com/data}
#'
"nominate"
