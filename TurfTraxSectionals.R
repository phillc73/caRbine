# Load requried libraries

require(ggplot2)
require(reshape2)

# Set working directory 
setwd("~/documents/Horse Racing/Sectionals")

# Load CSV file. Name needs updating each time.

csvfilename <- "GoodwoodAug1Race4.csv"

originalcsv <- read.csv(file=csvfilename, sep=",", header=TRUE, fileEncoding="latin1")

# Stuff for the plotting
# Remove Draw column

PlotData <- within(originalcsv, rm(Draw))

# Use melt from reshape2 libraruy to convert data from long to wide

PlotData <- melt(PlotData, id.vars=c("Horse"), variable.name="Furlong",value.name="Time")

# Remove the Xs from the furlong distances. This occured when they were column names. R doesn't like numbers starting column names.

levels(PlotData$Furlong) <- gsub("X", "", levels(PlotData$Furlong))

# Plot the graph

ggplot(data=PlotData, aes(x=Furlong, y=Time, colour=Horse, group=Horse)) + geom_line() + geom_point()

# Save the file as a jpg, using the edited csvfilename

picfilename <- substring(csvfilename, 1, nchar(csvfilename)-4)

picfilename <- paste(picfilename,".jpg", sep="")

ggsave(file=picfilename)

# Count total number of columns in the original CSV

ColCount <- ncol(originalcsv)

# Total Distance of race. Total number of columns, minus first two containing horse and draw, gives total furlongs.

originalcsv$Dist <- ColCount - 2

# Calculate sectional distance. For races longer than 8f it is 3 furlongs, otherwise 2 furlongs

originalcsv$SectDist <- ifelse(originalcsv$Dist > 8, 3, 2)

# Calculate sectional distance for early calcs. For races longer than 8f it is columns 3 to 5, otherwise columsn 2 to 4

SectDistEarly <- ifelse(originalcsv$Dist > 8, 5, 4)

# Calculate number of columns to use for sustained sectionals (sum of all bar final sectionals)

SectDistSust <- originalcsv$Dist - originalcsv$SectDist

# Calculate total time of race. Starting at column 3, through to WP column (ColCount provides accurate number), add all times.

originalcsv$TotTime <- rowSums(originalcsv[ , 3:ColCount])

# Number of columns to count across to when adding total late sectional time.

SectColCount <- ColCount - originalcsv$SectDist

# Calculate late sectional times. Total time minus sum of relevant early rows.

originalcsv$SectTimeLate <- (originalcsv$TotTime) - (rowSums(originalcsv[ , 3:SectColCount[1]]))

# Calculate early sectional times. Sum of first rows, starting at column 3 across to SectDistEarly column number (which will be 4 or 5)

originalcsv$SectTimeEarly <- rowSums(originalcsv[ , 3:SectDistEarly[1]])

# Calculate sustained sectional times. Sum of rows 3 to SectColCount number

originalcsv$SectTimeSust <- rowSums(originalcsv[ , 3:SectColCount[1]])

# Calculate final sectional percentages and rank

originalcsv$FinPercent <- (originalcsv$TotTime*originalcsv$SectDist*100)/(originalcsv$Dist*originalcsv$SectTimeLate)

originalcsv$FinRank <- rank (-originalcsv$FinPercent)

# Calculate early sectionals percentages

originalcsv$EarlyPercent <- (originalcsv$TotTime*originalcsv$SectDist*100)/(originalcsv$Dist*originalcsv$SectTimeEarly)

# Calculate sustained sectionals percentages

originalcsv$SustPercent <- (originalcsv$TotTime*(originalcsv$Dist-originalcsv$SectDist)*100)/(originalcsv$Dist*originalcsv$SectTimeSust)

# Hold just final sectionals in new variable for easy display on screen.

FinalSectionals <- subset(originalcsv, select=c(Horse, FinPercent))

FinalSectionals$FinPercent <- round(FinalSectionals$FinPercent, 3)

# Final Percent rankings and rivals beaten

FinalSectionals$FinRank <- rank (-FinalSectionals$FinPercent)

# Hold just early sectionals, ordered by highest first, in new variable

EarlySectionals <- subset(originalcsv, select=c(Horse, EarlyPercent))

EarlySectionals$Horse <- as.character(EarlySectionals$Horse)

EarlySectionals <- EarlySectionals[order(-EarlySectionals$EarlyPercent),]

# Hold just sustained sectionals, ordered by highest first, in new variable

SustSectionals <- subset(originalcsv, select=c(Horse, SustPercent))

SustSectionals <- SustSectionals[order(SustSectionals$SustPercent),]

# Energy Distribution and ranking, adding to Final Sectionals variable

FinalSectionals$EnergyDist <- (SustSectionals$SustPercent / FinalSectionals$FinPercent)^2

FinalSectionals$EnergyDist <- round(FinalSectionals$EnergyDist, 3)

FinalSectionals$EnergyRank <- rank(FinalSectionals$EnergyDist)

# Add Energy Distribution to Original CSV

originalcsv$EnergyDist <- FinalSectionals$EnergyDist

originalcsv$EnergyRank <- rank(originalcsv$EnergyDist)

# Display data on screen

EarlySectionals

SustSectionals

FinalSectionals

# Write out new CSV file with edited filename. This will retain original CSV in unamended form.

newcsvfilename <- gsub(".csv", "", csvfilename)

newcsvfilename <- paste(newcsvfilename,"Calcs",".csv",sep = "")

write.csv(originalcsv, file=newcsvfilename, quote=TRUE, row.names=FALSE) 
