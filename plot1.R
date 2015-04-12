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
DT1 <- DT[.(c("1/2/2007","2/2/2007")),c("Global_active_power"),with=F]
data <- as.numeric(as.character(DT1$Global_active_power))


## Save image to png file
png(filename = "plot1.png",
    width = 480,
    height = 480
    )

## Plot histogram
hist(data,
     ylim = c(0,1200),
     col = "red",
     main = "Global Active Power",
     ylab = "Frequency",
     xlab = "Global Active Power(killowatts)"
)

## End png
dev.off()

## clean up
rm(pkg,pkgs,url,DT,DT1,data)
unlink("./DATA",recursive=T)