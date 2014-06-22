## PLOT 1 OVERVIEW

#Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces a histogram of the frequency of Global Active Power consumption in kilowatts for the dates February 1 and 2, 2007. 

##PLOT 1 STEP-BY-STEP

#1 plot1("name of file here") starts the function. For example: plot1("household_power_consumption.txt")
#2 the file is read into R and assigned to the power variable 
#3 the date column is reformatted as recommended in the assignment instructions
#4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
#5 the Global_active_power col is reformatted as a numeric vector
#6 histogram is generated with the title "Global Active Power", red columns, and an x-axis label of "Global Active Power (kilowatts)"
#7 file is saved as "plot1.png"
#8 dev is closed
#9 statement is printed to let you know where the file has been successfully saved


## PLOT 2 OVERVIEW

#Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces a line graph of the Global Active Power consumption in kilowatts for the dates February 1 and 2, 2007. 

##PLOT 2 STEP-BY-STEP

#1 plot2("name of file here") starts the function. For example: plot2("household_power_consumption.txt")
#2 the file is read into R and assigned to the power data frame 
#3 the date column is reformatted as recommended in the assignment instructions
#4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
#5 the Global_active_power col is reformatted as a numeric vector
#6 a new column titled "timestamp" is added to df. This column consists of the date and time pasted together and reforamtted as a POSIXct class.
#7 plot is generated with timestamp on x-axis and global active power on y-axis. Default x-axis label is removed. Y-axis label is specified.
#8 png is generated as a 480 pixel by 480 pixel image. Its saved as "PLot2.png". Bitmap files default to pixels as their unit of measurement hence only using "480."
#9 statement is printed to let you know where the file has been successfully saved


## PLOT 3 OVERVIEW

#Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces one line graph of three sub metering levels for the dates February 1 and 2, 2007. 

##PLOT 3 STEP-BY-STEP

#1 plot3("name of file here") starts the function. For example: plot2("household_power_consumption.txt")
#2 the file is read into R and assigned to the power data frame 
#3 the date column is reformatted as recommended in the assignment instructions
#4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
#5 the Sub_metering cols are reformatted as numeric vectors
#6 a new column titled "timestamp" is added to df. This column consists of the date and time pasted together and reforamtted as a POSIXct class.
#7 plot is generated with timestamp on x-axis and sub metering levels on y-axis. Default x-axis label is removed. Y-axis label is specified. Legend is added with to the top right with line colors and variable names. 
#8 png is generated as a 480 pixel by 480 pixel image. Its saved as "plot3.png". Bitmap files default to pixels as their unit of measurement hence only using "480."
#9 statement is printed to let you know where the file has been successfully saved



## PLOT 4  OVERVIEW

#Reads in the “Individual household electric power consumption Data Set” available from the UC Irvine Machine Learning Repository, and produces four graphs for the dates February 1 and 2, 2007. 

##PLOT 4 STEP-BY-STEP

#1 plot4("name of file here") starts the function. For example: plot2("household_power_consumption.txt")
#2 the file is read into R and assigned to the power data frame 
#3 the date column is reformatted as recommended in the assignment instructions
#4 the two days of interest are subsetted out of the power data frame and assigned to new data frame named "df"
#5 the Sub_metering,Voltage, Global_active_power, and Global_reactive_power cols are reformatted as numeric vectors
#6 a new column titled "timestamp" is added to df. This column consists of the date and time pasted together and reformatted as a POSIXct class.
#7 Plot Layout is changed from (1,1) to (2,2) using the par command. 
#8 Each plot is generated. A png is generated as a 480 pixel by 480 pixel image. Its saved as "plot4.png". Bitmap files default to pixels as their unit of measurement hence only using "480."
#9 statement is printed to let you know where the file has been successfully saved
