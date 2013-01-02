# Load the packages we need

require(RCurl)
require(XML)

# Our UKHR login credentials. Later we will move these to a separate config file

ukhrusername = "yourukhrusername"
ukhrpassword = "yourukhrpassword"

# Which Mission selections do we want to download. Use full Mission number. e.g. 01, 02, 03, etc 10, 10a, 10b etc, 

mission = "07"

# Construct our URL to retrieve today's obsfucated URL, with the relevant login credentials

currentdayIDURL <- paste("http://www.ukhorseracing.co.uk/members/getsuffix.asp?UID=", ukhrusername, "&PWD=", ukhrpassword, sep="")

# Download today's obsfucated URL

getcurrentdayID <- getURL(currentdayIDURL) 

# Write the returned XML file to disk

write.table(getcurrentdayID, file = "currentdayID.xml", row.names = FALSE, col.names = FALSE, quote = FALSE) 

# Extract just the ID from the XML file

storedpageID = xmlRoot(xmlTreeParse("currentdayID.xml"))

function(node) 
	xmlSApply(node, xmlValue)

currentdayID = xmlSApply(storedpageID[[2]], xmlValue)

# Find today's date in the relevant format

datetoday <- format(Sys.Date(), "%Y%m%d")

# Construct the full download URL for today's summary CSV

todaymissionURL <- paste("http://www.ukhorseracing.co.uk/selections/xml/Mission", mission, currentdayID, ".csv", sep="")

# Retrieve the CSV and write it to file with relevant name and today's date

todaymissionCSV <- getURL(todaymissionURL)

todaymissionCSVfilename <- paste("Mission", mission, "_", datetoday, ".csv", sep="")

write.table(todaymissionCSV, file = todaymissionCSVfilename, row.names = FALSE, col.names = FALSE, quote = FALSE) 
