## plot2.R
 
## ----getData, results='hold', purl=TRUE, cache=FALSE---------------------

library(data.table, warn.conflicts = FALSE, quietly = TRUE, verbose=FALSE)

dataFile <- "household_power_consumption.txt"
zipFile <- "household_power_consumption.zip"

if (!file.exists(dataFile)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, zipFile, method="curl", mode="wb")
  unzip(zipFile, setTimes=TRUE)
}

print(paste("the file", dataFile, 
            "was downloaded/extracted on:", file.info(zipFile)$mtime))

# read the file into data.table, grepping only dates 1/2/2007 and 2/2/2007 
## LIGHTENING FAST!!
DT <- fread(
  paste("grep ^[12]/2/2007", dataFile),
  na.strings = c("?", ""))
# "grep" lost the headers, so get them
setnames(DT, colnames(fread(dataFile, nrows=0)))

# get English day names
Sys.setlocale(category = "LC_TIME", locale = "C")

# convert Date,Time to POSIXct
DT <- DT[, DateTime:=as.POSIXct(paste(Date,Time),             # convert Date,Time to DateTime
                                format="%d/%m/%Y %H:%M:%S", tz="UTC")
       ][, `:=`(Date=NULL, Time=NULL)                         # eliminate Date,Time cols
       ]


## ----plot2, results='hide', purl=TRUE, fig.width=5, fig.height=5---------

# prepare the plot
plot(DT$DateTime, DT$Global_active_power,
     type = "l",                                   # line plot
     bg = "white",
     xlab = NA,                                    # no label for x-axis
     ylab = "Global Active Power (kilowatts)")

# copy the screen plot to png file
dev.copy(png, file = "plot2.png",
              width = 480, height = 480, units = "px")
dev.off() ## Don't forget to close the PNG device!

