## PLOT 2 OVERVIEW

##Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces a line graph of the Global Active Power consumption in kilowatts for the dates February 1 and 2, 2007. 

##PLOT 2 STEP-BY-STEP

##1 plot2("name of file here") starts the function. For example: plot2("household_power_consumption.txt")
##2 the file is read into R and assigned to the power data frame 
##3 the date column is reformatted as recommended in the assignment instructions
##4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
##5 the Global_active_power col is reformatted as a numeric vector
##6 a new column titled "timestamp" is added to df. This column consists of the date and time pasted together and reforamtted as a POSIXct class.
##7 plot is generated with timestamp on x-axis and global active power on y-axis. Default x-axis label is removed. Y-axis label is specified.
##8 png is generated as a 480 pixel by 480 pixel image. Its saved as "PLot2.png". Bitmap files default to pixels as their unit of measurement hence only using "480."
##9 statement is printed to let you know where the file has been successfully saved

plot2 <- function(file) {
        power <- read.table(file, header=T, sep=";")
        power$Date <- as.Date(power$Date, format="%d/%m/%Y")
        df <- power[(power$Date=="2007-02-01") | (power$Date=="2007-02-02"),]
        
        df$Global_active_power <- as.numeric(as.character(df$Global_active_power))
        df <- transform(df, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
        
        plot(df$timestamp,df$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
        
        dev.copy(png, file="plot2.png", width=480, height=480)
        dev.off()
        cat("plot2.png has been saved in", getwd())
}

