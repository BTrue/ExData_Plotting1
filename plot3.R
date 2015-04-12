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
         c("Date","Time","Sub_metering_1","Sub_metering_2","Sub_metering_3"),
         with=F
         ]

## Convert and format Date and Time to single column
DT$Date <- as.Date(DT$Date,format = "%d/%m/%Y")
DT$DateTime <- paste(DT$Date,DT$Time)
x <- strptime(DT$DateTime,"%Y-%m-%d %H:%M:%S")
y1 <- as.numeric(as.character(DT$Sub_metering_1))
y2 <- as.numeric(as.character(DT$Sub_metering_2))
y3 <- as.numeric(as.character(DT$Sub_metering_3))
     
## Save image to png file
png(filename = "plot3.png",
    width = 480,
    height = 480
)

## Plot 
plot(x,y1,type = "l",xlab = "",ylab = "Energy sub metering")
lines(x,y2,type = "l",col="Red")
lines(x,y3,type = "l",col="Blue")
leg.txt <- c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legend("topright",
       y = NULL,
       legend = leg.txt,
       col = c("Black","Red","Blue"),
       border = NULL,
       bty = "o",
       lwd = 1,
       box.col = "Black",
       box.lwd = 1,
             
)
## End png
dev.off()

## clean up
rm(pkg,pkgs,url,DT,x,y1,y2,y3)
unlink("./DATA",recursive=T)