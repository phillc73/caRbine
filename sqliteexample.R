# An R script to create an SQLite database from a CSV file

# Load any required libraries

require("RSQLite")

# Set the working directory

setwd("~/set/directory/path/to/suit")

# Load the relevant CSV file. Change CSV filename to suit

csvfilename <- "example.csv"

originalcsv <- read.csv(file=csvfilename, sep=",", header=TRUE, fileEncoding="latin1", stringsAsFactors=FALSE)

# Rename columns as appropriate

colnames(originalcsv) <- c("Date", "Horse", "RaceTime", "Course", "Trainer", "Jockey", "Result", "StartPrice")

# Uncomment the following line to view dataframe format
#head(originalcsv)

# Uncomment the following line to view dataframe character types
# str(originalcsv)

# Change data types as appropriate. Date must be changed for SQLite compatibility

originalcsv$Date <- as.Date(originalcsv$Date, format="%d/%m/%Y")
originalcsv$Date <- as.character(originalcsv$Date)
originalcsv$StartPrice <- as.numeric(originalcsv$StartPrice)

# Write new database. One will be created if it does not exist. If database exists, new lines will be appended to it

con <- dbConnect(SQLite(), "example.sqlite")

dbWriteTable(con, name="example_data", value=transform(originalcsv, Date), row.names=FALSE, append=TRUE)

dbDisconnect(con)

# Check everything worked as expected by querying the database and counting rows. Match this with a row count of the original CSV.

con <- dbConnect(SQLite(), "example.sqlite")

sql1 <- paste("SELECT example_data.Horse FROM example_data", sep="")

results <- dbGetQuery(con, sql1) 

dbDisconnect(con)

dbrowcount <- aggregate(Horse ~ Horse, data = results, FUN = length)

csvrowcount <- nrow(originalcsv)

dbrowcount
csvrowcount
