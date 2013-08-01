# Enter Mission name as found in the original CSV. Must be an exact match.

mission = "Markpor"

# Enter original CSV Filename

csv_filename = "summaryCSV.csv"

# Read original CSV

originalcsv <- read.csv(file=csv_filename, sep=",", header=TRUE, fileEncoding="latin1") 

# String match for the selected Mission.

newmission_subset <- subset(originalcsv, grepl(mission, originalcsv$Systems))

# Subset just the relevant fields from the daily CSV. This could probably be cut even further.

newmission_subset <- subset(newmission_subset, select=c(Meeting, Time, RaceType, CardNumber, Horse, Going, Furlongs, Jockey, Trainer, Systems, RawRanking, RAdjRanking, JockeyRanking, TrainerRanking, TrFormRanking, ConnRanking, FrmRanking, LstRanking, ClsRanking, WinFRanking, SpdRanking, HCPRanking))

# Begin selecting matching UKHR Underscore pairings. These pairings have been chosen through analysis available on the UKHR Google Group.

cls_winf <- subset(newmission_subset, newmission_subset$ClsRanking==1 & newmission_subset$WinFRanking==1)

cls_trainer <- subset(newmission_subset, newmission_subset$ClsRanking==1 & newmission_subset$TrainerRanking==1)

cls_raw <- subset(newmission_subset, newmission_subset$ClsRanking==1 & newmission_subset$RawRanking==1)

cls_jockey <- subset(newmission_subset, newmission_subset$ClsRanking==1 & newmission_subset$JockeyRanking==1)

cls_hcp <- subset(newmission_subset, newmission_subset$ClsRanking==1 & newmission_subset$HCPRanking==1)

radj_trform <- subset(newmission_subset, newmission_subset$RAdjRanking==1 & newmission_subset$TrFormRanking==1)

frm_trform <- subset(newmission_subset, newmission_subset$FrmRanking==1 & newmission_subset$TrFormRanking==1)

frm_jockey <- subset(newmission_subset, newmission_subset$FrmRanking==1 & newmission_subset$JockeyRanking==1)

hcp_trform <- subset(newmission_subset, newmission_subset$HCPRanking==1 & newmission_subset$TrFormRanking==1)

jockey_lst <- subset(newmission_subset, newmission_subset$JockeyRanking==1 & newmission_subset$LstRanking==1)

trform_winf <- subset(newmission_subset, newmission_subset$TrFormRanking==1 & newmission_subset$WinFRanking==1)

scheduled_time, course, name, trainer_name.x, trainer_AE, jockey_name.x, jockey_AE))

# Bind all the dataframes together. There is probably a better way to do this.

daily_data <- rbind(cls_winf, cls_trainer)
daily_data <- rbind(daily_data, cls_raw)
daily_data <- rbind(daily_data, cls_jockey)
daily_data <- rbind(daily_data, cls_hcp)
daily_data <- rbind(daily_data, radj_trform)
daily_data <- rbind(daily_data, frm_trform)
daily_data <- rbind(daily_data, frm_jockey)
daily_data <- rbind(daily_data, hcp_trform)
daily_data <- rbind(daily_data, jockey_lst)
daily_data <- rbind(daily_data, trform_winf)

# Write new CSV

TodayDate <- Sys.Date()
FileEnd <- ".csv"
FileName<- paste(TodayDate,"-",mission,FileEnd,sep = "") 

write.csv(daily_data, file=FileName, quote=TRUE, row.names=FALSE) 

