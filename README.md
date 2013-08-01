caRbine
=======

A set of R scripts for automated horse racing actions. These scripts are designed to work with the data provided by the UK Horse Racing website - http://www.ukhorseracing.co.uk. You will need a subscription to this website for these scripts to work.

INSTALL
=======

To begin with, install R. All instructions below will be Linux focused, if you want to do this on Windows you'll need to figure it out yourself. 

On a Debian machine, from the command line:

> sudo apt-get install r-base r-base-dev

Install some additional libraries we'll need later:

> sudo apt-get install libcurl4-openssl-dev libxml2-dev

Make sure your R installation directory is writeable:

> sudo chmod 777 /usr/local/lib/R/site-library 

Start R, by typing:

> R

Within the R interpreter. We'll need to install some libraries from CRAN:

> install.packages(RCurl)

> install.packages (XML)

Exit R with:

> q()

Now we're ready to go.

USE
===

The scripts need to be downloaded to a working directory and ensure they are executable, and the directory writeable. (use chmod 777, or 755 perhaps if you're security conscious).

Open the script in a text editor and insert your UKHR username and password,  on lines 8 and 9, replacing the dummy text inside the inverted commas. Save the script. Save it as plain text, and not ASCII. The script is fully commented.

Execute the script, from the command line:

> R CMD BATCH summarcsv.R

This will execute the script. The current directory will need to be writeable, and a few new files will appear in there.

missioncsv.R and summarycsv.R:

a) currentdayID.xml – this file contains the obsfucated ID for the day, which is used to “hide” the URL for downloading files each day from the UKHR website.

b) summarycsv.Rout  - if you open this in a text editor it will show you the output of running the R script. It's a good places to look for any errors.

c) summaryCSV.csv – the summary CSV for the day. The file we've been looking for!

These scripts can be run using Cron, and should be run after midnight to ensure the dates are all correct

historic_mission_subset.R:

This script extracts specific Mission selections from the UK Horse Racing provided monthly result summary file. Script does not require entry of username or password. Mission name and monthly CSV filename must be added. Script is fully commented.

markpor_subset.R:

This script extracts specific selections based on Markpor's Trainers' Form and various paired top ranking Underscores (past form indicators). This system was developed from discussion on the UKHR Google Group and has shown a strong positive return, both historically prior to June 30th, 2013 and as a live system with over 55 bets in July 2013. 

This script will contain duplicate lines if a horse qualifies on multiple Underscore pairings, which will be useful if you wish to bet once for each matching underscore pairing. 

This script can be used in conjunction with summarycsv.R on the current day's UKHR CSV data. However, it can be used standalone, but the daily CSV filename should be changed to match the relevant local filename.

TO DO:
======

a) Develop further scripts to download historic data from the UKHR website and build a database of this data

b) Develop further scripts to interogate the data to find new profitable systems

c) Develop further scripts to automatically place bets
