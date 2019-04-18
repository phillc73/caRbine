library(dplyr)

# Find today's date in the relevant format

datetoday <- format(Sys.Date(), "%Y%m%d")
csv_filename <- paste("summaryCSV_", datetoday, ".csv", sep = "")

# Load today's Summary CSV file, assumed to be in the current working directory
# This assumes the file has been downloaded with the summaryCSV.R script

daily_data <- read.csv(csv_filename, stringsAsFactors = FALSE)

# Step wise filters of the data for qualifiers. 
# Filters in use:
# Flat and AW only, no NH
# Ratings Position 1 or Value Odds Probability > = 0.138
# Within 10 pounds of the top rated
# More than 5 runners
# ClassDiffDifference1Year not equal to zero
# Either Top Rated or last race rating rank less than 8

vop14 <- daily_data %>% 
  dplyr::filter(grepl("AW|Flat", RaceType)) %>%
  dplyr::filter(!grepl("NH", RaceType)) %>%
  dplyr::filter(RatingsPosition == 1 | ValueOdds_Probability >= 0.138) %>%
  dplyr::filter(RatingAdvantage >= -10) %>%
  dplyr::filter(Runners >= 5) %>%
  dplyr::filter(ClassDiffDifference1Year != 0) %>%
  dplyr::filter(RatingsPosition == 1 | LastRaceRatingRank <= 8) 

# Calculate Edge
# Then divide Forecast Betfair SP by decimal probability to find Edge. Value of 1.0 equals same prices.
vop14$Edge <- vop14$BetFairSPForecastWinPrice / vop14$ValueOdds_BetfairFormat

# Remove those with edge less than 1. That is Forecast BSP is lower than Probability decimal
vop14 <- dplyr::filter(vop14, Edge >= 1.00)

# Find the Median edge for the day and filter for only qualifiers above the median
vop14_median <- median(vop14$Edge)

vop14 <- dplyr::filter(vop14, Edge >= vop14_median)
  
# Order by earliest time
vop14 <- vop14[order(vop14$Time),] 

# Select just the columns we want to keep
vop14 <- dplyr::select(vop14, 
                       Meeting, 
                       Time, 
                       Horse, 
                       RaceType, 
                       Handicap, 
                       Age, 
                       BetFairSPForecastWinPrice, 
                       ValueOdds_BetfairFormat, 
                       Edge,
                       Runners, 
                       RatingAdvantage, 
                       RatingsPosition, 
                       ClassDiffDifference1Year, 
                       LastRaceRatingRank)

# Write the file out to a new csv
vop14_csv_filename <- paste("vop14_", datetoday, ".csv", sep = "")
write.csv(vop14, file = vop14_csv_filename, row.names = FALSE)
