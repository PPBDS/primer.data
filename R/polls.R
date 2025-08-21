#' Florida Senate Election Poll Data
#'
#' This dataset is polling data from a Florida Senate election survey in 2018 by New York Times Upshot.
#' The poll started October 2, 2018 and ended October 6, 2018.
#' This data includes respondent demographics, political preferences, and 
#' survey weights for analysis of voter attitudes and turnout likelihood.
#' 
#' The 2018 Florida Senate election was one of the most closely contested and 
#' significant races in the country, as it was considered key to determining 
#' control of the U.S. Senate. The race featured incumbent Democratic Senator 
#' Bill Nelson, who was seeking his fourth term, against Republican Governor 
#' Rick Scott, who was term-limited as governor. The election was extremely 
#' close, with initial results showing a margin of less than 0.25 percentage 
#' points, which triggered both machine and hand recounts under Florida law. 
#' After nearly two weeks of recounting and legal challenges, Rick Scott 
#' ultimately won with a final margin of 10,033 votes out of more than 8 
#' million votes cast. Nelson conceded the race on November 18, 2018, ending 
#' his 18-year Senate career and giving Republicans a crucial pickup in their 
#' efforts to maintain Senate control.
#' 
#' @format A data frame with 9 variables:
#' \describe{
#'   \item{response}{Respondent's candidate choice in the Senate race. Values are either "Democratic" (chose the Democratic candidate) or "Republican" (chose the Republican candidate).}
#'   \item{education}{Educational background of the respondent. Values include "Grade school" (completed elementary/primary education only, typically through 8th grade), "High school" (completed high school education with diploma or equivalent), "Some college or trade school" (attended college or vocational training but did not complete a bachelor's degree), "Bachelor's degree" (completed a 4-year undergraduate college degree), "Graduate or Professional Degree" (completed advanced education beyond bachelor's level such as master's, PhD, JD, MD, etc.), and "Refused" (declined to answer the education question).}
#'   \item{race}{Racial and ethnic identity of respondents. Values include "Asian", "Black", "Hispanic", "White", "Other", and "Refused"}
#'   \item{sex}{Sex of survey participants. Values include "Male", "Female".}
#'   \item{approve}{Political approval ratings. Values are "Approve" (approves of the political figure/policy being measured), "Disapprove" (disapproves of the political figure/policy being measured), or "Do Not Know" (unsure or has no opinion about their approval).}
#'   \item{region}{Geographic location within Florida. Values are "Central" (Central Florida region), "I-4" (Interstate 4 corridor region), "North/Rural" (Northern Florida and rural areas), "Southeast" (Southeastern Florida, includes areas like Miami-Dade and Broward), or "Southwest" (Southwestern Florida, includes areas like Naples and Fort Myers).}
#'   \item{turnout_score}{Likelihood-to-vote score measuring how probable each respondent was to actually cast a ballot on election day.}
#'   \item{final_weight}{Statistical weight applied to each response to ensure the poll accurately represents Florida's voting population.}
#'   \item{phone_type}{Type of phone used to contact the respondent. Values include "cell" (contacted via mobile/cellular phone) or "landline" (contacted via traditional landline telephone).}
#' }
#'
#' @details
#' 
#' The original data file was "elections-poll-flsen-3.csv" and has been
#' processed to rename variables for consistency and select relevant columns
#' for analysis.
#'
#' @source Raw data file: https://github.com/TheUpshot/2018-live-poll-results/blob/master/data/elections-poll-flsen-3.csv
"polls"