## Check then install packages used in script
pkgs <- c("data.table")
for(pkg in pkgs){
     if(!require(pkg,character.only=T)){
          suppressWarnings(require(pkg,quietly=T,warn.conflicts=F))
     }
}

## Download and read data file the web
if(!file.exists("./DATA")){dir.create("./DATA")}
setwd("./DATA")
url <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url,"data.zip",method="wget",quiet=T)
unzip("data.zip")
DT <- fread("household_power_consumption.txt",
            sep = ";",
            header = T,
            na.strings = "?",
            colClasses = list(character = 3:9)
)

## Subset data table for dates 
setkey(DT,Date)
DT <- DT[.(c("1/2/2007","2/2/2007")),
         c("Date",
           "Time",
           "Global_active_power",
           "Global_reactive_power",
           "Voltage",
           "Sub_metering_1",
           "Sub_metering_2",
           "Sub_metering_3"),
         with=F
         ]

## Convert and format Date and Time to single column
DT$Date <- as.Date(DT$Date,format = "%d/%m/%Y")
DT$DateTime <- paste(DT$Date,DT$Time)
x <- strptime(DT$DateTime,"%Y-%m-%d %H:%M:%S")
y <- as.numeric(as.character(DT$Global_active_power))
y1 <- as.numeric(as.character(DT$Sub_metering_1))
y2 <- as.numeric(as.character(DT$Sub_metering_2))
y3 <- as.numeric(as.character(DT$Sub_metering_3))
y4 <- as.numeric(as.character(DT$Voltage))
y5 <- as.numeric(as.character(DT$Global_reactive_power))

## Save image to png file
png(filename = "plot4.png",
    width = 480,
    height = 480
)

## Setup panel plot
par(mfrow = c(2,2),
    mfcol = c(2,2)
)

## Plot 1
plot(x,y,type = "l",xlab = "",ylab = "Global Active Power")

## Plot 2
plot(x,y1,type = "l",xlab = "",ylab = "Energy sub metering")
lines(x,y2,type = "l",col="Red")
lines(x,y3,type = "l",col="Blue")
leg.txt <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legend("topright",
       y = NULL,
       legend = leg.txt,
       col = c("Black","Red","Blue"),
       border = NULL,
       bty = "n",
       lwd = 1 
)

## Plot 3 
plot(x,y4,type="l",xlab="datetime",ylab="Voltage")

## Plot 4
plot(x,y5,type="l",xlab="datetime",ylab="Global_reactive_power")

## End png
dev.off()

## clean up
rm(pkg,pkgs,url,DT,x,y1,y2,y3,y4,y5,y,leg.txt)
unlink("./DATA",recursive=T)