## PLOT  OVERVIEW

##Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces four graphs for the dates February 1 and 2, 2007. 

##PLOT 4 STEP-BY-STEP

##1 plot4("name of file here") starts the function. For example: plot2("household_power_consumption.txt")
##2 the file is read into R and assigned to the power data frame 
##3 the date column is reformatted as recommended in the assignment instructions
##4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
##5 the Sub_metering,Voltage, Global_active_power, and Global_reactive_power cols are reformatted as numeric vectors
##6 a new column titled "timestamp" is added to df. This column consists of the date and time pasted together and reformatted as a POSIXct class.
##7 Plot Layout is changed from (1,1) to (2,2) using the par command. 
##8 Each plot is generated. 
##8 png is generated as a 480 pixel by 480 pixel image. Its saved as "plot4.png". Bitmap files default to pixels as their unit of measurement hence only using "480."
##9 statement is printed to let you know where the file has been successfully saved

plot4 <- function(file) {
        power <- read.table(file, header=T, sep=";")
        power$Date <- as.Date(power$Date, format="%d/%m/%Y")
        df <- power[(power$Date=="2007-02-01") | (power$Date=="2007-02-02"),]
        
        df$Sub_metering_1 <- as.numeric(as.character(df$Sub_metering_1))
        df$Sub_metering_2 <- as.numeric(as.character(df$Sub_metering_2))
        df$Sub_metering_3 <- as.numeric(as.character(df$Sub_metering_3))
        df$Global_active_power <- as.numeric(as.character(df$Global_active_power))
        df$Global_reactive_power <- as.numeric(as.character(df$Global_reactive_power))
        df$Voltage <- as.numeric(as.character(df$Voltage))
        
        df <- transform(df, timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
        
        par(mfrow=c(2,2))
        
        ##PLOT 1
        plot(df$timestamp,df$Global_active_power, type="l", xlab="", ylab="Global Active Power")
        ##PLOT 2
        plot(df$timestamp,df$Voltage, type="l", xlab="datetime", ylab="Voltage")
        
        ##PLOT 3
        plot(df$timestamp,df$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
        lines(df$timestamp,df$Sub_metering_2,col="red")
        lines(df$timestamp,df$Sub_metering_3,col="blue")
        legend("topright", col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), bty="n", cex=.5) #bty removes the box, cex shrinks the text, spacing added after labels so it renders correctly
        
        #PLOT 4
        plot(df$timestamp,df$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
        
        
        dev.copy(png, file="plot4.png", width=480, height=480)
        dev.off()
        cat("plot4.png has been saved in", getwd())
}