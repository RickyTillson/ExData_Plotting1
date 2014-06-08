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

# plot to png and close the link
png(filename = "plot2.png", width = 480, height = 480, units = "px")
with(wanted_data,
    plot(wanted_data[[10]],
         wanted_data[[3]],
         type = "n",
         xlab = "",
         ylab = "Global Active Power (kilowatts)"))
with(wanted_data,
     lines(wanted_data[[10]],
           wanted_data[[3]]))
dev.off()