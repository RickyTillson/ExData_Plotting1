# look for a directory called Data within the working directory
# if not found then create one
if(!file.exists("./Data")) {
    dir.create("./Data")
}

# look for text file, if it exists then move on
if(!file.exists(".Data/household_power_consumption.txt")) {
    # look for the zip file within the Data directory, if not found then download it
    if(!file.exists("./Data/raw_data.zip")) {
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, destfile = "./Data/raw_data.zip", method = "curl")
    }
    # the actual unzip part
    unzip("./Data/raw_data.zip", exdir = "./Data")
}

# read the data in and convert the type of the required column
library(data.table)
wanted_data <- fread("./Data/household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE, na.strings = "?")[Date == "1/2/2007" | Date == "2/2/2007"]

# concatenate date and time together before converting the data types
wanted_data[, data_and_time:= paste(wanted_data$Date,wanted_data$Time, sep = " " )]
wanted_data[[10]] <- as.POSIXct(strptime(wanted_data[[10]], "%d/%m/%Y %H:%M:%S"))
wanted_data[[3]] <- as.numeric(wanted_data[[3]])
wanted_data[[4]] <- as.numeric(wanted_data[[4]])
wanted_data[[5]] <- as.numeric(wanted_data[[5]])
wanted_data[[7]] <- as.numeric(wanted_data[[7]])
wanted_data[[8]] <- as.numeric(wanted_data[[8]])
wanted_data[[9]] <- as.numeric(wanted_data[[9]])

# plot to png and close the link
png(filename = "plot4.png", width = 480, height = 480, units = "px")
par(mfcol = c(2,2))
# first plot
with(wanted_data,
     plot(wanted_data[[10]],
          wanted_data[[3]],
          type = "n",
          xlab = "",
          ylab = "Global Active Power"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[3]]))
# second plot
with(wanted_data,
     plot(wanted_data[[10]],
          wanted_data[[7]],
          type = "n",
          xlab = "",
          ylab = "Energy sub metering"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[7]],
           col = "black"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[8]],
           col = "red"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[9]],
           col = "blue"))
legend("topright",
       col = c("black", "red", "blue"),
       lty = c(1,1,1),
       bty = "n",
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
# third plot
with(wanted_data,
     plot(wanted_data[[10]],
          wanted_data[[5]],
          type = "n",
          xlab = "datetime",
          ylab = "Voltage"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[5]]))
# fourth plot
with(wanted_data,
     plot(wanted_data[[10]],
          wanted_data[[4]],
          type = "n",
          xlab = "datetime",
          ylab = "Global_reactive_power"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[4]]))
dev.off()