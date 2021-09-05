#' @title
#' Trump's Twitter insults (2014-2021)
#'
#' @description This dataset was published by Ayush Garg
#'   \href{https://www.kaggle.com/ayushggarg/all-trumps-twitter-insults-20152021}{on
#'    Kaggle}. His analysis is based on a comparison between all tweets from the
#'   Trump Twitter Archive and a list of insulting Trump tweets published by The
#'   New York Times. Since there is no way to define what constitutes an insult,
#'   this may not necessarily represent a complete list of what someone might
#'   consider insulting tweets.
#'
#'
#' @format A tibble with 10,359 observations and 4 variables:
#' \describe{
#'   \item{date}{date varibale for the date on which President Trump posted an insulting tweet}
#'   \item{target}{character variable for the target of the insult}
#'   \item{insult}{character variable for the insult}
#'   \item{tweet}{character variable for the text of the complete tweet}
#
#' }
#'
#' @author
#' David Kane
#'
#' @source \url{https://www.kaggle.com/ayushggarg/all-trumps-twitter-insults-20152021}
#'
"insults"
