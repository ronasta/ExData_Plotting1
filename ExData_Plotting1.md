# ExData Course Project 1
Ronald Stalder  
`r Sys.Date()`  

## get and read the data

**Data Set Information from the [UCI web site](https://archive.ics.uci.edu/ml/datasets/Individual+household+electric+power+consumption#):**

```
This archive contains 2075259 measurements gathered between December 2006 and November 2010 (47 months). 
Notes: 
1.(global_active_power*1000/60 - sub_metering_1 - sub_metering_2 - sub_metering_3) represents the active energy consumed every minute (in watt hour) in the household by electrical equipment not measured in sub-meterings 1, 2 and 3. 
2.The dataset contains some missing values in the measurements (nearly 1,25% of the rows). All calendar timestamps are present in the dataset but for some timestamps, the measurement values are missing: a missing value is represented by the absence of value between two consecutive semi-colon attribute separators. For instance, the dataset shows missing values on April 28, 2007.


Attribute Information:

1.date: Date in format dd/mm/yyyy 
2.time: time in format hh:mm:ss 
3.global_active_power: household global minute-averaged active power (in kilowatt) 
4.global_reactive_power: household global minute-averaged reactive power (in kilowatt) 
5.voltage: minute-averaged voltage (in volt) 
6.global_intensity: household global minute-averaged current intensity (in ampere) 
7.sub_metering_1: energy sub-metering No. 1 (in watt-hour of active energy). It corresponds to the kitchen, containing mainly a dishwasher, an oven and a microwave (hot plates are not electric but gas powered). 
8.sub_metering_2: energy sub-metering No. 2 (in watt-hour of active energy). It corresponds to the laundry room, containing a washing-machine, a tumble-drier, a refrigerator and a light. 
9.sub_metering_3: energy sub-metering No. 3 (in watt-hour of active energy). It corresponds to an electric water-heater and an air-conditioner.
```



```r
library(data.table, warn.conflicts = FALSE, quietly = TRUE, verbose=FALSE)

dataFile <- "household_power_consumption.txt"
zipFile <- "household_power_consumption.zip"

if (!file.exists(dataFile)) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url,zipFile,method="curl",mode="wb")
  unzip(zipFile, setTimes=TRUE)
}

print(paste("the file", dataFile, 
            "was downloaded/extracted on:", file.info(zipFile)$mtime))

# read the file into a data.table
DT <- as.data.table(read.table(
          dataFile,
          header=TRUE,
          sep=";",
          na.strings="?",
          stringsAsFactors=FALSE
      ))

# extract dates 2007-02-01 and 2007-02-02, convert Date,Time to POSIXct
DT <- DT[Date %in% c("1/2/2007", "2/2/2007"),                 # select these dates
       ][, DateTime:=as.POSIXct(paste(Date,Time), tz="UTC")   # convert Date,Time to DateTime
       ][, `:=`(Date=NULL, Time=NULL)]                        # eliminate Date,Time
```

```
## [1] "the file household_power_consumption.txt was downloaded/extracted on: 2015-01-05 19:35:56"
```

