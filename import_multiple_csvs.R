# A very short R script to read in a directory of csv files, which all have the same data structure
# and create an fst archive file.
#
# Load libraries
# fst is used as the archive file format
# https://github.com/fstpackage/fst
library(fst)
library(data.table)

# Set the path where the csvs can be found
path <- paste("~/path/to/your/files")

# List all the csv files in the directory
files <- list.files(path, "*.csv", full.names = TRUE)

# Read in the CSV file with data.table::fread. Create as a data.frame
# rbindlist them all together
csv_data <- rbindlist(lapply(files, fread))

# write an fst file, default compression settings
write.fst(csv_data, "archive.fst")

# Read back the fst file if required
read_archive <- read.fst("archive.fst")
