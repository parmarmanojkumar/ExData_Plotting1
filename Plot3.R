#step 0 : Setting up Environment
cat("\014")
rm(list=ls())
getwd()

#step 1 : Download file
if(!file.exists("./assignmentdata")){
        dir.create("./assignmentdata")
}
downloadUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
if(!file.exists("./assignmentdata/household_power_consumption.zip")){
        download.file(downloadUrl,
                      destfile="./assignmentdata/household_power_consumption.zip",
                      method="curl")
}

#step 2 : Unzip file
if(!file.exists("./assignmentdata/household_power_consumption.txt")){
        unzip(zipfile="./assignmentdata/household_power_consumption.zip",
              exdir="./assignmentdata")
}
#step 3 : get the list of files from unzipped version to process it further.
datafilepath<- file.path("./assignmentdata" , "household_power_consumption.txt")

#step 4 : Read data file
powerdata <- read.table(datafilepath,sep=";",header=TRUE, na.strings = "?")

#step 5 : extract observations and convert date time to posix format
powersubdata <- powerdata[powerdata$Date %in% c("1/2/2007", "2/2/2007"),]
powersubdata$DateTime  <- strptime(paste(powersubdata$Date,powersubdata$Time),
                                   "%d/%m/%Y %H:%M:%S")
powersubdata$Date <- NULL
powersubdata$Time <- NULL

#step 6 : Plot the graphics
if(!file.exists("./figure")){
        dir.create("./figure")
}
png(filename = "./figure/plot3.png", width = 480, height = 480,
    units = "px", bg= "white")
plot(powersubdata$DateTime, powersubdata$Sub_metering_1,
     ylab = "Energy sub metering", xlab = "",
     type = "n")
lines(powersubdata$DateTime, powersubdata$Sub_metering_1, col= "black")
lines(powersubdata$DateTime, powersubdata$Sub_metering_2, col= "red")
lines(powersubdata$DateTime, powersubdata$Sub_metering_3, col= "blue")
legend("topright",col = c("black","red","blue"),
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       cex = 0.8, lwd = 1)
dev.off()

