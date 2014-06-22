##Before running the function, place the following files in the same directory as this script
# SCC_PM25.rds
# Source_Classification_Code.rds

plot_1 <- function(){
        ##PLOT 1
        ##Required packages
        library(plyr) 
        library(reshape2)
        ##Read in data and merge
        #NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        df <- subset(SCC, select = c("SCC", "Short.Name"))
        NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)
        
        #Sum Emissions by Year
        plot_1 <- aggregate(Emissions ~ year, NEI_SCC, sum)
        #Convert Emissions unit from "tons" to "thousands of tons"
        plot_1$Emissions <- plot_1$Emissions/1000
        #Change year column to Year
        plot_1 <- rename(plot_1, c("year"="Year"))
        #Create Plot Graphic
        ##Y-axis: Emissions (thousand tons)
        ##X-axis: Year
        ##Title: "Total US PM2.5 Emissions"
        ##Suppress X-axis labels
        plot(plot_1$Year,plot_1$Emissions, main="Total US PM2.5 Emissions", "b", xlab="Year", ylab="Emissions (thousands of tons)",xaxt="n")
        #Customize X-axis labels
        axis(side=1, at=c("1999", "2002", "2005", "2008"))
        #Set margins
        par(mar=c(5.1,5.1,4.1,2.1))
        #Output plot to PNG
        dev.copy(png, file="plot_1.png", width=720, height=480)
        dev.off()
}


plot_2 <- function(){
        ##Required packages
        library(plyr) 
        library(reshape2)
        ##Read in data and merge
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        df <- subset(SCC, select = c("SCC", "Short.Name"))
        NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)
        
        #Subset data for only Baltimore observations
        plot_2 <- subset(NEI_SCC, fips == "24510", c("Emissions", "year","type"))
        #Sum Emissions for each year 
        plot_2 <- aggregate(Emissions ~ year, plot_2, sum)
        #Convert Emissions unit to "thousand tons"
        plot_2$Emissions <- plot_2$Emissions/1000
        #Rename Year column
        plot_2 <- rename(plot_2, c("year"="Year"))
        #Create Plot Graphic
        ##Y-axis: Emissions (thousand tons)
        ##X-axis: Year
        ##Title: "Total Baltimore PM2.5 Emissions"
        ##Suppress X-axis labels
        plot(plot_2$Year,plot_2$Emissions, main="Total Baltimore PM2.5 Emissions", "b", xlab="Year", ylab="Emissions (thousand tons)",xaxt="n")
        #Create custom axis
        axis(side=1, at=c("1999", "2002", "2005", "2008"))
        #Set margins
        par(mar=c(5.1,4.1,5.1,2.1))
        #Output to PNG file
        dev.copy(png, file="plot_2.png", width=720, height=480)
        dev.off()
}   
        
plot_3 <- function(){ 
        ##Required packages
        library(plyr) 
        library(reshape2)
        library(ggplot2)
        ##Read in data and merge
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        df <- subset(SCC, select = c("SCC", "Short.Name"))
        NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)
        
        #Subset data for only Baltimore observations
        plot_3 <- subset(NEI_SCC, fips == "24510", c("Emissions", "year","type"))
        #Melt data for reshaping
        plot_3 <- melt(plot_3, id=c("year", "type"), measure.vars=c("Emissions"))
        #Reshape data summing Emissions by year then type
        plot_3 <- dcast(plot_3, year + type ~ variable, sum)
        #Plot data with ggplot2
        ##X-Axis: Year
        ##Y-Axis: Emissions (tons)
        ##Grouped by "type" with different colored line per type
        ##Draw lines
        ##Define point size, shape, and color
        ##Add axis labels and title
        ##Output plot to file
        ggplot(data=plot_3, aes(x=year, y=Emissions, group=type, color=type)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Emissions (tons)") + ggtitle("Baltimore PM2.5 Emissions by Type and Year")
        ggsave(file="plot_3.png")
}

plot_4 <- function(){ 
        ##Required packages
        library(plyr) 
        library(reshape2)
        library(ggplot2)
        ##Read in data and merge
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        df <- subset(SCC, select = c("SCC", "Short.Name"))
        NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)
        
        #Subset data where Short.Name—which indicates emissions source—contains 'Coal'. I made a decision to use a strict definition fo Coal to capture the two Coal related categories listed here under Fuel Combustion:http://www.epa.gov/air/emissions/basic.htm
        plot_4 <- subset(NEI_SCC, grepl('Coal',NEI_SCC$Short.Name, fixed=TRUE), c("Emissions", "year","type", "Short.Name"))
        #Convert Emissions unit to "thousands of tons"
        plot_4$Emissions <- plot_4$Emissions/1000
        #Aggregate data by summin Emissions for each year
        plot_4 <- aggregate(Emissions ~ year, plot_4, sum)
        #Plot data with ggplot2
        ##X-Axis: Year
        ##Y-Axis: Emissions (thousands of tons)
        ##Grouped by "type" with different colored line per type
        ##Draw lines
        ##Define point size, shape, and color
        ##Add axis labels and title
        ##Output plot to file
        ggplot(data=plot_4, aes(x=year, y=Emissions)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Emissions (thousands of tons)") + ggtitle("Total United States PM2.5 Coal Emissions")
        ggsave(file="plot_4.png")
}     

plot_5 <- function(){ 
        ##Required packages
        library(plyr) 
        library(reshape2)
        library(ggplot2)
        ##Read in data and merge
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        df <- subset(SCC, select = c("SCC", "Short.Name"))
        NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)
        
        #Subset data for Balitmore and emissions that occured on the road. For this analysis, the type ON-ROAD was used as an indicator of motor vehicle emissions. 
        plot_5 <- subset(NEI_SCC, fips == "24510" & type =="ON-ROAD", c("Emissions", "year","type"))
        #Aggregate data by year
        plot_5 <- aggregate(Emissions ~ year, plot_5, sum)
        #Plot data with ggplot2
        ##X-Axis: Year
        ##Y-Axis: Emissions (thousands of tons)
        ##Grouped by "type" with different colored line per type
        ##Draw lines
        ##Define point size, shape, and color
        ##Add axis labels and title
        ##Output plot to file
        ggplot(data=plot_5, aes(x=year, y=Emissions)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Emissions (tons)") + ggtitle("Motor Vehicle PM2.5 Emissions in Baltimore")
        ggsave(file="plot_5.png")
}

plot_6 <- function(){ 
        ##Required packages
        library(plyr) 
        library(reshape2)
        library(ggplot2)
        ##Read in data and merge
        NEI <- readRDS("summarySCC_PM25.rds")
        SCC <- readRDS("Source_Classification_Code.rds")
        df <- subset(SCC, select = c("SCC", "Short.Name"))
        NEI_SCC <- merge(NEI, df, by.x="SCC", by.y="SCC", all=TRUE)
        
        #Subset for Los Angeles and Baltimore, again using ON-ROAD type as indicator of motor vehicle emissions. 
        plot_6 <- subset(NEI_SCC, (fips == "24510" | fips == "06037") & type =="ON-ROAD", c("Emissions", "year","type", "fips"))
        #Rename "fips" to city
        plot_6 <- rename(plot_6, c("fips"="City"))
        #Rename city labels for more descriptive plotting
        plot_6$City <- factor(plot_6$City, levels=c("06037", "24510"), labels=c("Los Angeles, CA", "Baltimore, MD"))
        #Melt data for reshaping
        plot_6 <- melt(plot_6, id=c("year", "City"), measure.vars=c("Emissions"))
        #Reshape data summing emissions by city (i.e.fips) then year
        plot_6 <- dcast(plot_6, City + year ~ variable, sum)
        #Calculate change from year to year as difference between the two years. Add the number to a new column.
        plot_6[2:8,"Change"] <- diff(plot_6$Emissions)
        #Do not have 1998 data so initialize difference to 0 for each city.
        plot_6[c(1,5),4] <- 0
        #Plot data with ggplot2
        ##X-Axis: Year
        ##Y-Axis: Emissions (thousands of tons)
        ##Grouped by "type" with different colored line per type
        ##Draw lines
        ##Define point size, shape, and color
        ##Add axis labels and title
        ##Output plot to file
        ggplot(data=plot_6, aes(x=year, y=Change, group=City, color=City)) + geom_line() + geom_point( size=4, shape=21, fill="white") + xlab("Year") + ylab("Change in Emissions (tons)") + ggtitle("Motor Vehicle PM2.5 Emissions Changes: Baltimore vs. LA")
        ggsave(file="plot_6.png")
        
}