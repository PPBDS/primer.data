# If you have a var that returns "haven_labelled" (up to this point
# this is the only form of labelled var I have dealt with )

# ---------------------------------

ex1 <- data %>%
  select(var) %>%

  # this function is listed on Haven's package website

  mutate(new_var = as_factor(var))

class(ex1$new_var)
# returns: "factor"

# ---------------------------------

# Other functions that may be useful are

haven::labelled()

# for creating labelled vars

dplyr::recode()
dplyr::recode_factor()

# and

dplyr::case_when()

# for changing factor values by hand / if you have a key between integer
# factor levels and strings etc. (example case being census occupation
# codes, data shows a 4-5 digit code similar to a FIPS #, but the census
# bureau has a conversion excel file)

# These are what I have used in the past in various workarounds. The easiest
# and most accurate solve I've used has been as_factor(x) -->
# case_when(specify_labels_individually), but this has an upper bound limit
# on the time you have to do this if you have more than a reasonably small
# number of levels.
# Fortunately/unfortunately I don't have a super formulaic solution for large
# scale cases nor have Idiscovered a super efficient way to take the labels of
# a given var and make the labels into the same/ a new col of its own.
# Not sure what you're working on specifically, but this is the basis of
# what I have used/seen to this point.




