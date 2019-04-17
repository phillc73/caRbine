# Load the packages we need

library(RCurl)
library(XML)

# Our UKHR login credentials. Later we will move these to a separate config file.

ukhrusername = "yourukhrusername"
ukhrpassword = "yourukhrpassword"

# Construct our URL to retrieve today's obsfucated URL, with the relevant login credentials

currentdayIDURL <- paste("https://www.ukhorseracing.co.uk/members/getsuffix.asp?UID=", ukhrusername, "&PWD=", ukhrpassword, sep="")

# Download today's obsfucated URL

getcurrentdayID <- getURL(currentdayIDURL) 

# Extract just the ID from the XML

storedpageID <- xmlRoot(xmlTreeParse(getcurrentdayID))

function(node) 
  xmlSApply(node, xmlValue)

currentdayID <- xmlSApply(storedpageID[[2]], xmlValue)

# Find today's date in the relevant format

datetoday <- format(Sys.Date(), "%Y%m%d")

# Construct the full download URL for today's summary CSV

todaysummaryURL <- paste("https://www.ukhorseracing.co.uk/members/ratings/", datetoday, "summary", currentdayID, ".csv", sep="")

# Retrieve the summary CSV, which comes as a large character of text

todaysummaryCSV <- getURL(todaysummaryURL)

# Convert large character to dataframe and then write to CSV

todaysummary_df <- read.csv(text = todaysummaryCSV)
write.csv(todaysummary_df, file = "summaryCSV.csv", row.names = FALSE)

