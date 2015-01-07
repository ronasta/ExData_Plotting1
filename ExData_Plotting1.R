
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



## ----plot1, results='hide', purl=TRUE, fig.width=5, fig.height=5---------

# prepare the plot
hist(DT$Global_active_power,
     col = "red",
     bg = "white",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")

# copy the screen plot to png file
dev.copy(png, file = "plot1.png",
              width = 480, height = 480, units = "px")
dev.off() ## Don't forget to close the PNG device!



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



## ----plot3, results='hide', purl=TRUE, fig.width=5, fig.height=5---------

# prepare plot, take sub_metering_1 for y-axis as it has the highest max
plot(DT$DateTime, DT$Sub_metering_1,
     type = "l", col="black", lty="solid", lwd=1,
     bg = "white",
     xlab = NA,
     ylab = "Energy sub metering")
lines(DT$DateTime, DT$Sub_metering_2, type="l", col="red", lty="solid", lwd=1)
lines(DT$DateTime, DT$Sub_metering_3, type="l", col="blue", lty="solid", lwd=1)
legend("topright", lty = "solid", lwd = 2, cex = .8,
       col = c("black", "red", "blue"), 
       legend = c("sub_metering_1 ", "sub_metering_2 ", "sub_metering_3 "))

# copy the screen plot to png file
dev.copy(png, file = "plot3.png",
              width = 480, height = 480, units = "px")
dev.off() ## Don't forget to close the PNG device!



## ----plot4, results='hide', purl=TRUE, fig.width=5, fig.height=5---------

par(mfrow = c(2,2), bg = "white")
with(DT, {

### @[1,1]: same as Plot 2

plot(DateTime, Global_active_power,
     type = "l",                                   # line plot
     xlab = NA,                                    # no label for x-axis
     ylab = "Global Active Power (kilowatts)")

### @[1,2]: like Plot 2, but with Voltage

plot(DateTime, Voltage,
     type = "l",                                   # line plot
     xlab = "datetime",
     ylab = "Voltage")

### @[2,1]: same as Plot 3

plot(DateTime, Sub_metering_1,
     type = "l", col="black", lty="solid", lwd=1,
     xlab = NA,
     ylab = "Energy sub metering")
lines(DateTime, Sub_metering_2, type="l", col="red", lty="solid", lwd=1)
lines(DateTime, Sub_metering_3, type="l", col="blue", lty="solid", lwd=1)
legend("topright", lty = "solid", lwd = 2, 
       bty = "n",                             # no box drawn
       cex = 0.7, y.intersp = 0.4,
       col = c("black", "red", "blue"), 
       legend = c("sub_metering_1 ", "sub_metering_2 ", "sub_metering_3 "))

### @[2,2]: like Plot 2, but with Global_reactive_power

plot(DateTime, Global_reactive_power,
     type = "l",
     col="black",
     xlab = "datetime",
     ylab = "Global_reactive_power")
  
})  ## end of with(DT...)

# copy the screen plot to png file
dev.copy(png, file = "plot4.png",
              width = 480, height = 480, units = "px")
dev.off() ## Don't forget to close the PNG device!


