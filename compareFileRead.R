# Course Data Scientist - Exploratory Data Analysis - Course Project 1

# compare the different methods of reading in
# the file "household_power_consumption.txt" and
# subsetting Date to 1/2/2007 and 2/2/2007

library(data.table)
library(sqldf)
Sys.setlocale(category = "LC_MESSAGES", locale = "C") # english output of system.time

dataFile <- "household_power_consumption.txt"

tdt <- system.time({
    DT <- fread(
      paste("grep ^[12]/2/2007", dataFile),
      na.strings = c("?", ""))
    # "grep" lost the headers, so get them
    setnames(DT, colnames(fread(dataFile, nrows=0)))
    # better, but slower: keeps the first line
#     DT <- fread(
#         paste("sed '1p;/^[12]\\/2\\/2007/!d'", dataFile),
#         na.strings = c("?", ""))
})
print("data.table")
print(tdt)

tdt <- system.time({
    dtime <- difftime(as.POSIXct("2007-02-03"), as.POSIXct("2007-02-01"),units="mins")
    rowsToRead <- as.numeric(dtime)
    DT <- fread("household_power_consumption.txt", 
                skip="1/2/2007", nrows = rowsToRead, na.strings = c("?", ""))
})
print("data.table.skip-nrows")
print(tdt)

tdf <- system.time({
  DF <- read.csv(
    dataFile, sep=";",
    stringsAsFactors=FALSE,
    na.strings = c("?", ""))
  # sub-set the Date
  DF <- DF[DF$Date %in% c("1/2/2007","2/2/2007"), ]
})
print("read.csv")
print(tdf)

tds <- system.time({
  DS <- read.csv.sql(
    file=dataFile, sep=";", header=TRUE,
    sql="select * from file where Date in ('1/2/2007','2/2/2007')",
    stringsAsFactors=FALSE,)
})
print("read.csv.sql")
print(tds)

print(summary(DT))
print(summary(DF))
print(summary(DS))
