# Enter Mission name as found in the original CSV. Must be an exact match.

mission = "Mission-08"

# Enter original CSV Filename

csv_filename = "2013_02_February.csv"

# Read original CSV

originalcsv <- read.csv(file=csv_filename, sep=",", header=TRUE, fileEncoding="latin1") 

# String match for the selected Mission

newmissionsubset <- subset(originalcsv, grepl(mission, originalcsv$Systems))

# Write new CSV

TodayDate <- Sys.Date()
FileEnd <- ".csv"
FileName<- paste(TodayDate,"-",mission,FileEnd,sep = "") 

write.csv(newmissionsubset, file=FileName, quote=TRUE, row.names=FALSE) 




