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
wanted_data[[3]] <- as.numeric(wanted_data[[3]])

# plot to png and close the link
png(filename = "plot1.png",
    width = 480,
    height = 480,
    units = "px")
with(wanted_data,
    hist(Global_active_power,
        col = "red",
        main = "Global Active Power",
        xlab = "Global Active Power (kilowatts)"))
dev.off()