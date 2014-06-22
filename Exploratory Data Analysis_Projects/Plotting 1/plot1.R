## PLOT 1 OVERVIEW

##Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces a histogram of the frequency of Global Active Power consumption in kilowatts for the dates February 1 and 2, 2007. 

##PLOT 1 STEP-BY-STEP

##1 plot1("name of file here") starts the function. For example: plot1("household_power_consumption.txt")
##2 the file is read into R and assigned to the power variable 
##3 the date column is reformatted as recommended in the assignment instructions
##4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
##5 the Global_active_power col is reformatted as a numeric vector
##6 histogram is generated with the title "Global Active Power", red columns, and an x-axis label of "Global Active Power (kilowatts)"
##7 file is saved as "plot1.png"
##8 dev is closed
##9 statement is printed to let you know where the file has been successfully saved

plot1 <- function(file) {
        
        power <- read.table(file, header=T, sep=";")
        power$Date <- as.Date(power$Date, format="%d/%m/%Y")
        
        df <- power[(power$Date=="2007-02-01") | (power$Date=="2007-02-02"),]
        
        df$Global_active_power <- as.numeric(as.character(df$Global_active_power))
        
        hist(df$Global_active_power, main = paste("Global Active Power"), col="red", xlab="Global Active Power (kilowatts)")
        
        dev.copy(png, file="plot1.png", width=480, height=480)
        dev.off()
        cat("Plot1.png has been saved in", getwd())
}