# Health and Economic Implications of Storms
Daniel Maurath  
July, 2014  


#### About
This was the second project for the **Reproducible Research** course in Coursera's Data Science specialization track. The purpose of the project was to determine which storm event(s) had the most significant economic and health effects.

## Synopsis
Severe weather has serious economic and health impacts, causing property damage, crop damage, injury and even death. The purpose of this assignment was to determine which severe weather types have the greatest economic and health effects. Economic effects were operationalized as the degree of property and crop damage. Health effects were operationalized as number of fatalities and injuries. 

I analyzed data taken from the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database. The data was far from tidy and needed some initial preprocessing prior to the analysis. 

The report begins with initial data processing followed by a subsequent analysis with the most important results plotted (no more than three plots were permitted for this assignment). I end the report with results and briefly discuss their implications. 

In short, results revealed that hurricanes have the most significant economic impact, while tornadoes are the most deadly. 

## R Session Information

### Additional Libraries and Session Environment

```r
library(ggplot2)
library(plyr)
library(reshape2)
library(knitr)

sessionInfo()
```

```
## R version 3.0.3 (2014-03-06)
## Platform: x86_64-apple-darwin10.8.0 (64-bit)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] knitr_1.6       reshape2_1.4    plyr_1.8.1      ggplot2_0.9.3.1
## 
## loaded via a namespace (and not attached):
##  [1] colorspace_1.2-4 digest_0.6.4     evaluate_0.5.5   formatR_0.10    
##  [5] grid_3.0.3       gtable_0.1.2     htmltools_0.2.4  MASS_7.3-29     
##  [9] munsell_0.4.2    proto_0.3-10     Rcpp_0.11.1      rmarkdown_0.2.54
## [13] scales_0.2.4     stringr_0.6.2    tools_3.0.3      yaml_2.1.11
```


## Retrieve Data
Data was retrieved via  [Coursera's Cloudfont Link](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2) and unzipped into the working directory. Uncomment the code below to download and unzip the data. File will download and save to current working directory. 


```r
URL <- "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
destfile <- "stormData.csv.bz2"
download.file(URL, destfile)

sData_complete <- read.csv(bzfile("stormData.csv.bz2"), strip.white = TRUE)
```

## Data Processing
Event data prior to 1996 was incomplete; it only contained Tornado, Thunderstorm, Wind and Hail event types, while data in 1996 and after contains all 48 event types that are in current use. Thus, this subset of data was considered best for analysis because event types were most evenly distributed.

Before subsetting by date, I reformatted the date column to remove hours and minutes, which were all zeros in this data set and inconsequential for the present analysis.


```r
sData_complete$BGN_DATE <- as.Date(sData_complete$BGN_DATE, format = "%m/%d/%Y")
```

Next, I subsetted the data first by only the variables that would provide information on health or economic consequences of storms, and then subsetted the data again to retrieve only those events that occurred in 1996 or later. 


```r
sData <- subset(sData_complete, select = c("EVTYPE","FATALITIES", "INJURIES", "PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP", "BGN_DATE", "REMARKS"))

sData <- subset(sData, sData$BGN_DATE > as.Date("1995-12-31"))
```

## Find NA Values
No missing values so moving on to examine data integrity. 


```r
countNAs <- function(dataframe) {
        for (colName in colnames(dataframe)) {
                NAcount <- 0
                NAcount < as.numeric(sum(is.na(dataframe[,colName])))
                if(NAcount > 0) {
                        message(colName, ":", NAcount, "missing values")
                        } else {
                        message(colName, ":", "No missing values")
                        }
                }
}
countNAs(sData)
```

```
## EVTYPE:No missing values
## FATALITIES:No missing values
## INJURIES:No missing values
## PROPDMG:No missing values
## PROPDMGEXP:No missing values
## CROPDMG:No missing values
## CROPDMGEXP:No missing values
## BGN_DATE:No missing values
## REMARKS:No missing values
```

## Property and Crop Damage Variables
To determine economic consequences of storms, I needed to calculate the total amount of damage in US Dollars. The data provided one column indicating the amount and another indicating the unit: "K" for thousands,"M" for millions, or "B" for billions. I needed to combine these two columns into a single column representing the total cost dollars for each observation.

First, I converted the unit character into its numeric equivalent(e.g. "K" became 1000).


```r
nested_ifelse <- function(x){
        x <- as.character(x)
        ifelse (x == "B", as.numeric(1000000000),
        ifelse(x == "M", as.numeric(1000000), 
        ifelse(x == "K", as.numeric(1000), 0)))
}
sData$PROPDMGEXP <- toupper(sData$PROPDMGEXP)
sData$PROPDMGEXP <- nested_ifelse(sData$PROPDMGEXP)
```

Next, I created a new column PROPDMGDOL that was the product of  the unit column and amount column.This is the total amount of property damage in US Dollars. 


```r
sData$PROPDMGDOL <- as.numeric(sData$PROPDMG*sData$PROPDMGEXP)
```

Then I did the same for crop damage, creating a new variable CROPDMGDOL that became the total amount of crop damage in US Dollars.


```r
sData$CROPDMGEXP <- toupper(sData$CROPDMGEXP)
sData$CROPDMGEXP <- nested_ifelse(sData$CROPDMGEXP)
sData$CROPDMGDOL <- as.numeric(sData$CROPDMG*sData$CROPDMGEXP)
```

### Outlier Investigation
Now that I have a dollar representation of the property and crop damage, I want to check for any outliers due to errors in data entry.

Mean and median are too low for traditional outlier analysis using a Z-test. Instead I looked for individual values that comprised 5% or more of the data. There were two data points that fit this cutoff.


```r
summary(sData$PROPDMGDOL)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## 0.00e+00 0.00e+00 0.00e+00 5.61e+05 1.25e+03 1.15e+11
```

```r
pmean <- mean(sData$PROPDMGDOL)
psum <- sum(sData$PROPDMGDOL)
prop_outliers <- sData[sData$PROPDMGDOL/psum > 0.05, ]
```

I pull out the remarks for the first data point 

```r
prop_outliers[1,9]
```

```
## [1] Storm surge damage in southeast Louisiana, especially in the New Orleans area and the coastal parishes, was catastrophic.  Hurricane protection levees and floodwalls were overtopped and/or breached resulting in widespread and deep flooding of homes and businesses.  Much of Orleans and Plaquemines Parishes and nearly all of St. Bernard Parish were flooded by storm surge. Approximately 80 percent of the city of New Orleans was flooded.  Thousands of people were stranded by the flood waters in homes and buildings and on rooftops for several days and had to be rescued by boat and helicopter. In Jefferson Parish, levees were not compromised, however many homes were flooded by either heavy rain overwhelming limited pumping capacity or storm surge water moving through in-operable pumps into the parish.  Severe storm surge damage also occurred along the north shore of Lake Pontchartrain from Mandeville to Slidell with storm surge water moving inland as far as Old Towne Slidell with water up to 6 feet deep in some locations\n\nPost storm high water surveys of the area conducted by FEMA indicated the following storm surge estimates:  Orleans Parish - 12-15 feet in east New Orleans to 9 to 12 feet along the Lakefront; St. Bernard Parish - 14 to 17 feet; Jefferson Parish - 6 to 9 feet along the lakefront to 5 to 8 feet from Lafitte to Grand Isle; Plaquemines Parish - 15 to 17 feet; St. Tammany Parish - 11 to 16 feet in southeast portion to 7 to 10 feet in western portion. All storm surge heights are still water elevations referenced to NAVD88 datum.
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```
Hurricane Katrina. Looks good.

I pull out the remarks for the second data point 

```r
prop_outliers[2,9]
```

```
## [1] Major flooding continued into the early hours of January 1st, before the Napa River finally fell below flood stage and the water receeded. Flooding was severe in Downtown Napa from the Napa Creek and the City and Parks Department was hit with $6 million in damage alone. The City of Napa had 600 homes with moderate damage, 150 damaged businesses with costs of at least $70 million.
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```
Remarks mention only millions yet damage is in the billions. Looks like a B was used instead of an M, so I will adjust the number. 


```r
sData[sData$PROPDMGDOL == 1.15e+11,c("PROPDMGDOL")] <- 70000000
```


No outliers in the crop 

```r
summary(sData$CROPDMGDOL)
```

```
##     Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
## 0.00e+00 0.00e+00 0.00e+00 5.32e+04 0.00e+00 1.51e+09
```

```r
cmean <- mean(sData$CROPDMGDOL)
csum <- sum(sData$CROPDMGDOL)
crop_outliers <-  sData[sData$CROPDMGDOL/csum > 0.05, ]
nrow(crop_outliers) > 0 
```

```
## [1] FALSE
```

With all outliers fixed, I calculated the total damage in US dollars and added it to a new variable.

```r
sData$TOTALDMGDOL <- sData$CROPDMGDOL + sData$PROPDMGDOL
```

## Event Type Data
This data contained a total of 516 unique event types, which is much higher than the standard 48 event types outlined in the  NOAA [directive](http://www.ncdc.noaa.gov/stormevents/pd01016005curr.pdf).


```r
sData$EVTYPE <- toupper(sData$EVTYPE)
length(unique(sData$EVTYPE))
```

```
## [1] 438
```

To aid in the EVTYPE cleanup I will create a couple utility functions that will monitor my progress.

- **match** returns all the event types that match the pattern. 
- **count_unique** returns number of remaining unmatched EVTYPES
- **list_unique** lists remaining unmatched EVTYPES. Uses a txt file import of the canonical 48 event types.

#### 48 Events
The list of 48 events used by the NOAA since 1996. 


```r
EVENTS <- read.table("48events.txt",
               col.names=c("EVTYPE"), 
               sep="\n",
               strip.white=TRUE)
print(EVENTS)
```

```
##                      EVTYPE
## 1     Astronomical Low Tide
## 2                 Avalanche
## 3                  Blizzard
## 4             Coastal Flood
## 5           Cold/Wind Chill
## 6               Debris Flow
## 7                 Dense Fog
## 8               Dense Smoke
## 9                   Drought
## 10               Dust Devil
## 11               Dust Storm
## 12           Excessive Heat
## 13  Extreme Cold/Wind Chill
## 14              Flash Flood
## 15                    Flood
## 16             Frost/Freeze
## 17             Funnel Cloud
## 18             Freezing Fog
## 19                     Hail
## 20                     Heat
## 21               Heavy Rain
## 22               Heavy Snow
## 23                High Surf
## 24                High Wind
## 25                Hurricane
## 26                Ice Storm
## 27         Lake-Effect Snow
## 28          Lakeshore Flood
## 29                Lightning
## 30              Marine Hail
## 31         Marine High Wind
## 32       Marine Strong Wind
## 33 Marine Thunderstorm Wind
## 34              Rip Current
## 35                   Seiche
## 36                    Sleet
## 37         Storm Surge/Tide
## 38              Strong Wind
## 39        Thunderstorm Wind
## 40                  Tornado
## 41      Tropical Depression
## 42           Tropical Storm
## 43                  Tsunami
## 44             Volcanic Ash
## 45               Waterspout
## 46                 Wildfire
## 47             Winter Storm
## 48           Winter Weather
```


```r
match <- function(pattern) {
        pattern <- toupper(pattern)
        unique(sData$EVTYPE[grepl(pattern, sData$EVTYPE)])
}

count_unique <- function() {
        length(unique(sData$EVTYPE))
}

list_unique <- function(col) {
                y <- toupper(EVENTS$EVTYPE)
                not_standard <- setdiff(col,y)
                l <- length(not_standard)
                message("The following ",l, " values are not in the standard 48 EVTYPES:")
                not_standard
               }
```

For example, I'll return all the values with TSTM.


```r
match("TSTM")
```

```
##  [1] "TSTM WIND"               "TSTM WIND/HAIL"         
##  [3] "TSTM WIND (G45)"         "TSTM HEAVY RAIN"        
##  [5] "TSTM WIND 40"            "TSTM WIND 45"           
##  [7] "TSTM WIND (41)"          "TSTM WIND (G40)"        
##  [9] "TSTM WND"                " TSTM WIND"             
## [11] "TSTM WIND AND LIGHTNING" " TSTM WIND (G45)"       
## [13] "TSTM WIND  (G45)"        "TSTM WIND (G35)"        
## [15] "TSTM WINDS"              "TSTM"                   
## [17] "TSTM WIND G45"           "NON-TSTM WIND"          
## [19] "NON TSTM WIND"           "MARINE TSTM WIND"
```

But before I can categorize TSTM Events, I need more information. TSTM could be Thunder Storm or Tropical Storm, but which is it? Let's look at the data. 

Here I subset the original data to regain the STATE variable. I pull out all EVTYPES with TSTM then sum them by state. If it means Tropical Storm, then all the top states should be along the southeastern and eastern coast of the US where most Tropical storms hit according to the [NOAA](http://www.nhc.noaa.gov/pdf/nws-nhc-6.pdf). KS, OK, OH, MO, IL, TN, AR, and PA are all in the top 10, without any sign of Florida, a popular landing spot for Tropical Storms. Looks like TSTM means Thunderstorm. A second quick test shows other non-Tropical Storm states like Idaho, Oregon and California.


```r
tstm <- subset(sData_complete,select = c("EVTYPE","STATE"))
tstm <- tstm[grepl("TSTM", tstm$EVTYPE),]
tstm <- as.data.frame(table(tstm$EVTYPE, tstm$STATE))
colnames(tstm) <- c("EVTYPE", "STATE","FREQ")                    
tstm <- tstm[order(-tstm$FREQ),]
head(tstm, 10)
```

```
##          EVTYPE STATE  FREQ
## 61926 TSTM WIND    TX 16713
## 21541 TSTM WIND    KS 11162
## 48136 TSTM WIND    OK 11053
## 47151 TSTM WIND    OH  9005
## 36316 TSTM WIND    MO  8627
## 13661 TSTM WIND    GA  8558
## 19571 TSTM WIND    IL  8550
## 60941 TSTM WIND    TN  8073
## 4796  TSTM WIND    AR  7946
## 50106 TSTM WIND    PA  7608
```

```r
head(tstm[tstm$EVTYPE=="TSTM WIND/HAIL",])
```

```
##               EVTYPE STATE FREQ
## 13678 TSTM WIND/HAIL    GA  102
## 12693 TSTM WIND/HAIL    FL  100
## 18603 TSTM WIND/HAIL    ID   71
## 49138 TSTM WIND/HAIL    OR   64
## 7768  TSTM WIND/HAIL    CA   63
## 38303 TSTM WIND/HAIL    MT   52
```

Change All to THUNDERSTORM WIND and recount event types. 

```r
sData$EVTYPE[grepl("MARINE TSTM WIND", sData$EVTYPE)]<-"MARINE THUNDERSTORM WIND"
sData$EVTYPE[grepl("NON-TSTM WIND|NON TSTM WIND", sData$EVTYPE)]<-"STRONG WIND"
sData$EVTYPE[grepl("TSTM WIND", sData$EVTYPE)]<-"THUNDERSTORM WIND"
```

### Organization of Clean Up
To stay organized, I started the EVTYPE clean up by matching events in alphabetical order. I began with trying to match Astronomical Low Tide, and ended with Wildfire. 

As I categorized EVTYPES during the second phase, I would add them where they belonged, instead of writing another line of code. So all EVTYPES that matched  EXCESSIVE COLD were added to the single line instead of being renamed as I categorized them. 

I did this...
```
sData$EVTYPE[grepl("EXTREME COLD|RECORD COOL|HYPOTHERMIA/EXPOSURE|HARD FREEZE|AGRICULTURAL FREEZE|UNSEASONAL LOW TEMP|LATE FREEZE|EXCESSIVE COLD|PROLONG COLD|UNUSUALLY COLD|EXTREME WINDCHILL|EXTREME WINDCHILL TEMPERATURES|EXTREME WIND CHILL|UNSEASONABLE COLD|EXTREME COLD/WIND CHILL|RECORD COLD|EXTENDED COLD|UNSEASONABLY COLD|RECORD  COLD|UNSEASONABLY COOL|EXTENDED COLD", sData$EVTYPE)]<-"EXTREME COLD/WIND CHILL"
```
instead of this...
```
sData$EVTYPE[grepl("EXTREME COLD", sData$EVTYPE)]<-"EXTREME COLD/WIND CHILL"
sData$EVTYPE[grepl("RECORD COOL", sData$EVTYPE)]<-"EXTREME COLD/WIND CHILL"
sData$EVTYPE[grepl("HYPOTHERMIA/EXPOSURE", sData$EVTYPE)]<-"EXTREME COLD/WIND CHILL"
etc.
```

If an event type matching was non-obvious, I supported it with an appropriate citation from either a web source or the remarks column. 

### Clean Up

```r
match("tide")
```

```
## [1] "BLOW-OUT TIDES"         "BLOW-OUT TIDE"         
## [3] "ASTRONOMICAL HIGH TIDE" "STORM SURGE/TIDE"      
## [5] "ASTRONOMICAL LOW TIDE"
```
Not sure where blow out tide fits in so I Google government sites using the following query:
```
blow out tide site:.edu
```
According to this [government source](http://www.dec.ny.gov/lands/59228.html), Blow Out Tides are abnormally low tides. I will count them as Astronomical Low Tides as per this definition, 
>"Abnormal, or extremely low tide levels, that result in deaths or injuries, watercraft damage, or significant economic impact due to low water levels. Astronomical low tides are made more extreme when strong winds produce a considerable seaward transport of water, resulting in previously submerged, non-hazardous objects become hazardous or exposed."

There is not a category for Astronomical High Tides, but according to the [directive](http://www.ncdc.noaa.gov/stormevents/pd01016005curr.pdf), Astronomical High Tides should be considered Storm Surge/Tide Events, 
>"Basically, storm tide is the sum of storm surge and astronomical tide."


```r
sData$EVTYPE[grepl("BLOW-OUT TIDE", sData$EVTYPE)]<-"ASTRONOMICAL LOW TIDE"
sData$EVTYPE[grepl("ASTRONOMICAL HIGH TIDE", sData$EVTYPE)]<-"STORM SURGE/TIDE"
```

Continue replacing values.

```r
sData$EVTYPE[grepl("BLIZZ", sData$EVTYPE)]<-"BLIZZARD"

sData$EVTYPE[grepl("COASTAL EROSION|COASTAL F|EROSION/CSTL FLOOD|CSTL FLOODING/EROSION|COASTALFLOOD|COASTAL  FLOODING/EROSION", sData$EVTYPE)]<-"COASTAL FLOOD"

sData$EVTYPE[grepl("EXTREME COLD|RECORD COOL|HYPOTHERMIA/EXPOSURE|HARD FREEZE|AGRICULTURAL FREEZE|UNSEASONAL LOW TEMP|LATE FREEZE|EXCESSIVE COLD|PROLONG COLD|UNUSUALLY COLD|EXTREME WINDCHILL|EXTREME WINDCHILL TEMPERATURES|EXTREME WIND CHILL|UNSEASONABLE COLD|EXTREME COLD/WIND CHILL|RECORD COLD|EXTENDED COLD|UNSEASONABLY COLD|RECORD  COLD|UNSEASONABLY COOL|EXTENDED COLD", sData$EVTYPE)]<-"EXTREME COLD/WIND CHILL"

sData$EVTYPE[grepl("COLD WIND CHILL TEMPERATURES|^WIND CHILL$|COOL SPELL|COLD WEATHER|BITTER WIND CHILL|BITTER WIND CHILL TEMPERATURES|^COLD$|COLD TEMPERATURE", sData$EVTYPE)]<-"COLD/WIND CHILL"
```

I used the [directive](http://www.ncdc.noaa.gov/stormevents/pd01016005curr.pdf) as support for categorizing Mudslides and Landslides as Debris Flow:

>The event name of Landslide was renamed to Debris Flow (cover page)

>When events such as mudslides or lahars are caused primarily by volcanic activity, or 
when rainfall is not the primary cause, then document them as a Debris Flow (page 33)


```r
sData$EVTYPE[grepl("MUDSLIDE|LANDSLUMP|MUDSLIDE/LANDSLIDE|LANDSLIDE|ROCK SLIDE|MUD SLIDE", sData$EVTYPE)]<-"DEBRIS FLOW"
```

Continued replacing values..

```r
sData$EVTYPE[grepl("DENSE FOG|^FOG$", sData$EVTYPE)] <- "DENSE FOG"
sData$EVTYPE[grepl("ICE FOG", sData$EVTYPE)]<-"FREEZING FOG"

sData$EVTYPE[grepl("SMOKE", sData$EVTYPE)]<-"DENSE SMOKE"

sData$EVTYPE[grepl("DROUGHT|DRY|RECORD LOW RAINFALL|DRIEST MONTH|SNOW DROUGHT", sData$EVTYPE)]<-"DROUGHT"
```


```r
match("dust")
```

```
## [1] "DUST STORM"   "DUST DEVIL"   "SAHARAN DUST" "DUST DEVEL"  
## [5] "BLOWING DUST"
```

Remarks reveals that Land spout is another term for a Dust Devil.

```r
sData[sData$EVTYPE=="LANDSPOUT",c("REMARKS")]
```

```
## [1] Trees, outdoor playset, and iron fence damaged\nA dust devil, or landspout, developed from fair weather clouds around 3:45 PM EDT on a 4 acre homestead outside of Laytonsville.  As it moved across an acre of the property, it broke tree spikes and bent the trees the spikes were supporting.  It also lifted a large outdoor swingset and threw it into an iron fence.  The fence was broken and the swingset sustained moderate damage, resulting in $5000 in losses.                                                                                                                               
## [2] Damage to tin roof on store, loosened shingles on home\n\n\nA landspout, or dust devil, developed from fair weather clouds around 3:30 PM EDT over the city of Harrisonburg.  It only lasted one minute, but it caused about $2000 in damage to a store on High Street.  The landspout produced very localized winds strong enough to push an employee of the store back inside.  The wind also ripped and buckled the southwest corner of the store's tin roof.  Free standing flowers 20 yards away from the structure were left untouched.  In addition, the wind loosened shingles on a home nearby.  
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData$EVTYPE[grepl("DUST DEVEL|LANDSPOUT", sData$EVTYPE)]<-"DUST DEVIL"
sData$EVTYPE[grepl("SAHARAN DUST|BLOWING DUST", sData$EVTYPE)]<-"DUST STORM"
```

Continue matching and replacing.

```r
sData$EVTYPE[grepl("HEATBURST|RECORD TEMPERATURE|RECORD HEAT|HEAT WAVE|RECORD HIGH|HOT SPELL|UNSEASONABLY HOT|HOT WEATHER|HYPERTHERMIA/EXPOSURE|TEMPERATURE RECORD", sData$EVTYPE)]<-"EXCESSIVE HEAT"

sData$EVTYPE[grepl("FLASH|DAM BREAK", sData$EVTYPE)]<-"FLASH FLOOD"
```

Unsure where Flood/Strong Wind fits in, I consult the Remarks column, which reveals that its a lake flood. 

```r
sData[sData$EVTYPE=="FLOOD/STRONG WIND", c("REMARKS")]
```

```
## [1] Lake Poinsett remained four feet overfull through the end of May and continued to flood many homes and cabins. Nearly fifteen families were still not able to get to their homes by the end of May. The high lake level combined with several days of strong winds gusting to 40 mph resulted in four foot waves on the lake. The days with the strongest winds were the 5th, 8th, 11th, and 13th. The high waves combined with floating debris, landscaping logs, railroad ties, timber, docks, etc., continued to cause considerable damage to cabins and homes around the lake. Broken windows and doors were the main things damaged. \n
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData$EVTYPE[grepl("FLOOD/STRONG WIND", sData$EVTYPE)]<-"LAKESHORE FLOOD"
```

Continue replacing. 

```r
sData$EVTYPE[grepl("STREET FLOODING|FLD|TIDAL FLOODING|MINOR FLOODING|RIVER FLOOD|URBAN/STREET FLOODING|URBAN FLOOD|RIVER FLOODING|SNOWMELT FLOODING|HIGH WATER", sData$EVTYPE)]<-"FLOOD"

sData$EVTYPE[grepl("FROST|COLD AND FROST|FIRST FROST|DAMAGING FREEZE|^FREEZE$", sData$EVTYPE)]<-"FROST/FREEZE"

sData$EVTYPE[grepl("FUNNEL CLOUDS|WALL CLOUD", sData$EVTYPE)]<-"FUNNEL CLOUD"

sData$EVTYPE[grepl("^HAIL$|HAIL/WIND|SMALL HAIL|ICE PELLETS|0.75|GUSTY WIND/HAIL|LATE SEASON HAIL|NON SEVERE HAIL", sData$EVTYPE)]<-"HAIL"

sData$EVTYPE[grepl("WARM", sData$EVTYPE)]<-"HEAT"

sData$EVTYPE[grepl("RAIN|WET|RAIN DAMAGE|HEAVY RAIN/WIND|HEAVY RAIN AND WIND|GUSTY WIND/HVY RAIN|RAIN (HEAVY)|EXCESSIVE RAIN|UNSEASONAL RAIN|EARLY RAIN|PROLONGED RAIN|MONTHLY RAINFALL|EXCESSIVE RAINFALL|RECORD PRECIPITATION|HEAVY RAINFALL|RECORD RAINFALL|LOCALLY HEAVY RAIN|TORRENTIAL RAINFALL|HEAVY RAIN EFFECTS|TSTM HEAVY RAIN",sData$EVTYPE)]<-"HEAVY RAIN"

sData$EVTYPE[grepl("FREEZING RAIN|RAIN/SNOW|FREEZING DRIZZLE|SLEET STORM|MIXED PRECIPITATION|SLEET/FREEZING RAIN|FREEZING RAIN/SLEET|MIXED PRECIP|FREEZING SPRAY|HEAVY PRECIPITATION|LIGHT FREEZING RAIN|SNOW/FREEZING RAIN|SNOW/SLEET|SNOW AND SLEET|LIGHT SNOW/FREEZING PRECIP",sData$EVTYPE)]<-"SLEET"

sData$EVTYPE[grepl("ICE JAM|BLACK ICE|^ICE$|ICE ROADS|PATCHY ICE|ICE ON ROAD|ICY ROADS|SNOW AND ICE|SNOW/ICE|FALLING SNOW/ICE|ICE/SNOW|GLAZE|THUNDERSNOW SHOWER",sData$EVTYPE)]<-"ICE STORM"

sData$EVTYPE[grepl("LAKE EFFECT SNOW",sData$EVTYPE)]<-"LAKE-EFFECT SNOW"

sData$EVTYPE[grepl("HEAVY SNOW|MOUNTAIN SNOWS|SEASONAL SNOWFALL|RECORD MAY SNOW|RECORD WINTER SNOW|^SNOW$|LATE SNOW|COLD AND SNOW|SNOW SQUALL|HEAVY SNOW SQUALLS|SNOW SQUALLS|RECORD SNOWFALL|LIGHT SNOW|MODERATE SNOW|MODERATE SNOWFALL|EARLY SNOWFALL|EXCESSIVE SNOW|MONTHLY SNOWFALL|RECORD SNOW|SNOW/BLOWING SNOW|BLOWING SNOW|LATE SEASON SNOW|METRO STORM, MAY 26|SNOW ADVISORY|UNUSUALLY LATE SNOW|ACCUMULATED SNOWFALL|SNOW SHOWERS|FIRST SNOW|SNOW ACCUMULATION|DRIFTING SNOW|LATE-SEASON SNOWFALL",sData$EVTYPE)]<-"HEAVY SNOW"

sData$EVTYPE[grepl("SURF|BEACH EROSION|SWELLS",sData$EVTYPE)]<-"HIGH SURF"

sData$EVTYPE[grepl("TYPHOON|HURRICANE|REMNANTS OF FLOYD",sData$EVTYPE)]<-"HURRICANE"

sData$EVTYPE[grepl("LIGHTNING",sData$EVTYPE)]<-"LIGHTNING"
```

Consult the remarks to replace four ambiguous events:
-Wind and Wave
-Gradient Wind
-Whirlwind
-Marine Accident

Added them to their appropriate categories below.


```r
match("wind")
```

```
##  [1] "THUNDERSTORM WIND"        "HIGH WIND"               
##  [3] "EXTREME COLD/WIND CHILL"  "STRONG WIND"             
##  [5] "WIND"                     "WIND DAMAGE"             
##  [7] "WINDS"                    "STRONG WINDS"            
##  [9] "WHIRLWIND"                "GUSTY WIND"              
## [11] "GRADIENT WIND"            "COLD/WIND CHILL"         
## [13] "GUSTY WINDS"              "STRONG WIND GUST"        
## [15] "HIGH WINDS"               "HIGH WIND (G40)"         
## [17] "WAKE LOW WIND"            "WIND ADVISORY"           
## [19] "WIND AND WAVE"            " WIND"                   
## [21] "NON-SEVERE WIND DAMAGE"   "THUNDERSTORM WIND (G40)" 
## [23] "WIND GUSTS"               "GUSTY LAKE WIND"         
## [25] "GUSTY THUNDERSTORM WINDS" "MARINE THUNDERSTORM WIND"
## [27] "GUSTY THUNDERSTORM WIND"  "MARINE HIGH WIND"        
## [29] "MARINE STRONG WIND"
```

```r
sData[sData$EVTYPE=="WIND AND WAVE",c("REMARKS")]
```

```
## [1] Douglas Lake Marina was hit by waves estimated at 4 to 6 feet and then a wind gust estimated at 45-55 mph.  One 300 foot section of the 3-section dock was totally destroyed.  15-20 boats were either damaged or destroyed.  Storm survey revealed no tree or structure damage on adjacent or upwind shoreline.
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData[sData$EVTYPE=="GRADIENT WIND",c("REMARKS")]
```

```
## [1] Strong gradient winds combined with saturated soils to blow down several trees in Jackson and Madison counties during the early morning hours. Wind speeds did not quite meet high wind criteria.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
## [2] Gusty west and northwest gradient winds associated with a passing cold front lifted the roof from a pawn shop in Wewoka.  Although the winds were sustained at 20 to 25 mph and gusting to only 30-35 mph at the time, the roof was lifted and flipped into an adjacent alley.  The roof hit several power lines, cutting power to most of the northern half of Wewoka. \n\nThe roof was poorly constructed, consisting of tin nailed to old wooden beams, which apparently were not well attached to the main structure.\n\n                                                                                                                                                                                                                   
## [3] Gradient induced winds flipped an 18-wheeler on FM 529 near Rosenberg.\n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
## [4] Gradient induced wind blew a tin roof off a patio in Shady Acres Subdivision.\n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
## [5] Gradient induced wind blew trees down in Memorial Park.\n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
## [6] Gradient induced wind blew trees down in Hempstead.\n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
## [7] Strong gradient winds blew powerlines and trees down in Bellville and throughout county.\n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
## [8] \nSummary for 4/23/01 gradient wind event:\nA vigorous low pressure system in Wisconsin brought a trailing cold front through Iowa and Illinois.  The system brought strong gradient winds to western Illinois. From late morning through sunset, a southwest wind gusted over 40 mph across the area.  The highest measured speed in northwest Illinois was 46 mph at the Quad City  Airport in Moline.  There was no significant damage reported.                                                                                                                                                                                                                                                                                             
## [9] \nSummary for 4/23/01 gradient wind event:\nA vigorous low pressure system in Wisconsin brought a trailing cold front through Iowa and Illinois.  During the early morning, around 12 AM CST, law enforcement reported a semi-trailer truck blown over along Interstate 80 in Iowa County.  A south wind gusted between 40 and 50 mph over a small part of east central Iowa during the early morning, including the Washington, Cedar Rapids, and Iowa City areas.  The area of strong winds moved north of the area by 1 AM CST.  Then from late morning through sunset, a southwest wind gusted over 40 mph across eastern Iowa.  The highest measured speed was 48 mph at the Clinton Municipal Airport.  No signficant damage was reported.
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData[sData$EVTYPE=="WHIRLWIND",c("REMARKS")]
```

```
## [1] A sky diver inadvertently crossed paths with a dust devil which aused his parachute to collapse about 30 feet above the ground.  The man died from injuries sustained in the resulting fall.  M39OU                                                                                                                                                         
## [2] Strong winds from a dust devil ripped through a mobile home park in North Las Vegas tearing awnings and shingles from residences and hurling them hundreds of feet through the air.                                                                                                                                                                         
## [3] A "whirlwind", occurring when a fairly strong sea breeze interacted with mechanical atmospheric mixing under clear, dry conditions, produced considerable damage at a home in the Town 'N' Country section of Hillsborough County.  Three cement support poles were lifted from the ground, and a metal rod was reportedly driven through the home's roof.\n
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData[sData$EVTYPE=="MARINE ACCIDENT",c("REMARKS")]
```

```
## [1] Heavy seas capsized a fishing vessel off of Fern Canyon when it was caught abeam by a large wave.  Two crew members were rescued but one drown.  M35BO
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData$EVTYPE[grepl("HIGH WIND|^WINDS$|GRADIENT WIND|GUSTY WIND|WIND DAMAGE|GUSTY WINDS|HIGH WINDS|HIGH WIND (G40)|WIND ADVISORY|WIND GUSTS|GUSTY LAKE WIND|WIND AND WAVE|DOWNBURST|MICROBURST",sData$EVTYPE)]<-"HIGH WIND"
sData$EVTYPE[grepl("^WIND$|^ WIND$|STRONG WINDS|STRONG WIND GUST|WND|WAKE LOW WIND",sData$EVTYPE)]<-"STRONG WIND"

sData$EVTYPE[grepl("^THUNDERSTORM WIND$|GUSTY THUNDERSTORM WINDS|GUSTY THUNDERSTORM WIND|G40",sData$EVTYPE)]<-"THUNDERSTORM WIND"
sData$EVTYPE[grepl("WHIRLWIND",sData$EVTYPE)]<-"MARINE STRONG WIND"
sData$EVTYPE[grepl("MARINE ACCIDENT",sData$EVTYPE)]<-"MARINE HIGH WIND"
sData$EVTYPE[grepl("SEAS$|ROGUE WAVE",sData$EVTYPE)]<-"MARINE THUNDERSTORM WIND"
```

NOAA does not have a Thunderstorm category. In this data, a look at the remarks for Thunderstorms  reveals that the few results of damage and fatalities attributable to Thunderstorms are in fact caused by wind.

```r
stm <- sData[grepl("^THUNDERSTORMS$|^TSTM$|COASTAL STORM|COASTALSTORM|^THUNDERSTORM$|SEVERE THUNDERSTORMS|SEVERE THUNDERSTORM", sData$EVTYPE),]

stm[stm$FATALITIES > 0, c("REMARKS")]
```

```
## [1]     \nA second coastal storm formed in less than 24 hours off the Mid-Atlantic Coast.  As it moved northeast off the coast, it spread heavy precipitation across the local area.\n\nThe precipitation began around 6 pm on December 7th in the form of rain along the coast, but was mixed with snow further inland.  Heavy rain was concentrated over Fairfield and Southern New Haven Counties.  Here are selected rainfall amounts:\n\n1.81 inches at Bridgeport\n1.13 inches at Danbury\n1.80 inches at New Haven.\n\nAs the low moved east of the area, rain changed to snow everywhere.  Snowfall amounts ranged from 0.5 inches at Bridgeport to 5.8 inches at Danbury.  Thundersnows occurred at Norwich, where a spotter measured 3 inches.  A pedestrian was struck in the blinding snow in Madison in Southern New Haven County.\n\n  ??OU                                                                                                                                                                                                                                                                                                                                                      
## [2]    \nA strong low pressure system developed just off the DELMARVA Coast early Friday morning and moved slowly northeast.  It passed south of Long Island during the late morning before moving east of Long Island Friday afternoon.\n\nIt produced heavy rain, strong gusty winds, and minor tidal flooding along the coast.  The storm also produced wet snow well inland, especially over higher terrain.\n\nRainfall amounts ranged from 1 to 2 inches.  Snowfall amounts ranged from 0.5 inches at Suffern in Rockland County  to 3.0 inches at Mahopac in Putnam County.  Most peak wind gusts ranged from 40 to 54  MPH.  The highest peak gust was 58 MPH at Bridgehampton in Suffolk County.\n\nIn Northern Westchester County, the combination of wet snow and strong gusty winds caused a tree to fall on a moving vehicle along the Sprain Brook Parkway.  A person was killed when the tree crushed his car.\n\nHere are selected rainfall amounts for:\n\nNew York City:  1.16 inches at JFK Airport and 1.20 inches at Central Park.\n\nNassau County:  1.36 inches at Farmingdale.\n\nSuffolk County:  from 1.20 inches at Westhampton to 1.81 inches at West Islip.\n\n  M53VE            
## [3]   \nAn intense low pressure system developed off the DELMARVA Coast during Monday morning.  It moved slowly east-northeast, passing south of Long Island Monday afternoon and southeast of Cape Cod, MA during Tuesday morning, April 1st.\n\nHeavy rain developed by late Monday morning.  As winds increased, it became wind-swept.  Rain gradually mixed with sleet and snow before it changed to wet snow  by Monday evening.  Peak wind gusts ranged from 40 to 50 mph. \n\nHere are selected rainfall amounts for:\n\nSouthern Fairfield County:  from 1.20 inches at Bethel to 1.49 inches at Bridgeport Airport.\n\nSouthern New Haven County:  from 1.28 inches at North Cheshire to 2.16 inches at East Haven.\n\nHere are selected snowfall amounts for:\n\nSouthern Fairfield County:  from 2 inches at Greenwich to 5.3 inches at New Canaan.\n\nSouthern New Haven County:  from 3 inches at Milford to 6 inches at New Haven.\n\nSouthern New London County:  4 inches at Groton.\n\nA Stamford man was killed on the Merritt Parkway in a car accident around 7:20 am.  His car slid off the snow-covered  road and slammed into a tree.\n  M39VE\n                                        
## [4]  \nAn intense low pressure system developed off the DELMARVA Coast during Monday morning.  It moved slowly east-northeast, passing south of Long Island Monday afternoon and southeast of Cape Cod, MA during Tuesday morning, April 1st.\n\nHeavy rain developed Monday morning.  As winds increased, it became wind-swept.  Rain gradually mixed with sleet and snow before it changed to wet snow during Monday night.  Although most peak wind gusts ranged from 40 to 50 mph, a 53 mph gust was measured at Kennedy Airport in Queens.\n\nHere are selected rainfall amounts for:\n\nNew York County:  1.39 inches at Central Park.\n\nQueens County:  from 1.17 inches at Kennedy Airport to 1.28 inches at LaGuardia Airport.\n\nSuffolk County:  from 1.64 inches at the National Weather Service (NWS) Office in Upton to 2.07 inches at Bridgehampton.\n\nHere are selected snowfall amounts for:\n\nNew York City:  from a trace at Central Park to 1.7 inches at Kennedy Airport.\n\nLong Island:  from 0.5 inches at Plum Island to 4 inches at the NWS Upton Office.\n\nA woman died after being pulled from her car, which had flipped over in the Sheldrake River in New Rochelle.  F49VE\n
## [5] Cold frontal passage and spring thunderstorms through Interior Central California during the afternoon hours resulted in low snow levels in shower activity.  In the Kern Mountains, snow clogged Interstate-5 with 1-inch of snow caused a traffic death near Lebec.\n                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
stm[stm$TOTALDMGDOL > 0, c("REMARKS")]
```

```
## [1] A coastal low pressure system that developed along the northeast U.S. coast from the remnants of Pacific Hurricane Fausto brought high winds and heavy rain to coastal Maine.  The storm brought up to 2 inches of rain to southern coastal locations, with scattered power outages and downed trees.  Five boats broke loose from their moorings in South Portland causing at least $50,000 in damages.  In Rockland, a 27 ft sailboat was also driven aground by the strong winds.  One woman suffered a shoulder injury in Freeport when she was hit by a hot dog stand, apparently blown by the wind. 
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData$EVTYPE[grepl("^THUNDERSTORMS$|COASTAL STORM|^TSTM$|COASTALSTORM|^THUNDERSTORM$|SEVERE THUNDERSTORMS|SEVERE THUNDERSTORM", sData$EVTYPE)] <- "THUNDERSTORM WIND"
```

Replace a few more. 

```r
sData$EVTYPE[grepl("RIP CURRENTS",sData$EVTYPE)]<-"RIP CURRENT"

sData$EVTYPE[grepl("STORM SURGE",sData$EVTYPE)]<-"STORM SURGE/TIDE"

sData$EVTYPE[grepl("TORN",sData$EVTYPE)]<-"TORNADO"
```

Not sure on what VOG is, so I consult the remarks and Wikipedia. According to Wikipedia:
>Vog is a form of air pollution that results when sulfur dioxide and other gases and particles emitted by an erupting volcano react with oxygen and moisture in the presence of sunlight. The word is a portmanteau of the words "volcanic", "smog", and "fog". 

```r
sData[sData$EVTYPE=="VOG", c("REMARKS")]
```

```
## [1] The high vog level sent people with respiratory problems to hospital emergency rooms, while outdoor activities were limited until the vog cleared off.  The state's Vog Index Hotline measured the vog at six on a scale of 10.  The volcanic haze built up from the eruption at Kilauea and the lack of trade winds caused increased smoglike conditions over part of Oahu.
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData$EVTYPE[grepl("VOLCANIC|VOG",sData$EVTYPE)]<-"VOLCANIC ASH"
```

Replace a couple more.

```r
sData$EVTYPE[grepl("WATERSPOUT",sData$EVTYPE)]<-"WATERSPOUT"

sData$EVTYPE[grepl("WINTER WEATHER|WINTERY MIX|WINTRY MIX|WINTER MIX|WINTER WEATHER MIX|WINTER WEATHER/MIX",sData$EVTYPE)]<-"WINTER WEATHER"
```

Consult remarks to find out that Red Flag Criteria is a reference to [wildfires](http://www.srh.noaa.gov/tae/?n=redflag)

```r
sData[sData$EVTYPE=="RED FLAG CRITERIA",c("REMARKS")]
```

```
## [1] The Red Flag Fire Weather Warnings were posted due to dry lightning with several fire starts reported in Interior Central California Fire Weather Zones #533 and #534 (the higher terrain of the Southern Sierra Nevada and Tulare County Mountains).
## [2] Several dry lightning fire starts were reported thus meeting verification criteria for Red Flag Fire Weather Warnings in CWFA Fire Zones.                                                                                                            
## 436781 Levels:  \t \t\t ... Zones 22 and 23 were added to the high wind warning of  January 26. Peak winds Sitka 55MPH, Cape Decision 58MPH, and Cape Spencer 64MPH.\n
```

```r
sData$EVTYPE[grepl("FIRE|RED FLAG CRITERIA",sData$EVTYPE)]<-"WILDFIRE"
```

I am at the end of the list. I check in to see how many matches I have left to make, and to see which EVTYPES are still unmatched. 

```r
count_unique()
```

```
## [1] 121
```

```r
list_unique(sData$EVTYPE)
```

```
## The following 73 values are not in the standard 48 EVTYPES:
```

```
##  [1] "OTHER"                  "SUMMARY JAN 17"        
##  [3] "SUMMARY OF MARCH 14"    "SUMMARY OF MARCH 23"   
##  [5] "SUMMARY OF MARCH 24"    "SUMMARY OF APRIL 3RD"  
##  [7] "SUMMARY OF APRIL 12"    "SUMMARY OF APRIL 13"   
##  [9] "SUMMARY OF APRIL 21"    "SUMMARY AUGUST 11"     
## [11] "SUMMARY OF APRIL 27"    "SUMMARY OF MAY 9-10"   
## [13] "SUMMARY OF MAY 10"      "SUMMARY OF MAY 13"     
## [15] "SUMMARY OF MAY 14"      "SUMMARY OF MAY 22 AM"  
## [17] "SUMMARY OF MAY 22 PM"   "SUMMARY OF MAY 26 AM"  
## [19] "SUMMARY OF MAY 26 PM"   "SUMMARY OF MAY 31 AM"  
## [21] "SUMMARY OF MAY 31 PM"   "SUMMARY OF JUNE 3"     
## [23] "SUMMARY OF JUNE 4"      "SUMMARY JUNE 5-6"      
## [25] "SUMMARY JUNE 6"         "SUMMARY OF JUNE 11"    
## [27] "SUMMARY OF JUNE 12"     "SUMMARY OF JUNE 13"    
## [29] "SUMMARY OF JUNE 15"     "SUMMARY OF JUNE 16"    
## [31] "SUMMARY JUNE 18-19"     "SUMMARY OF JUNE 23"    
## [33] "SUMMARY OF JUNE 24"     "SUMMARY OF JUNE 30"    
## [35] "SUMMARY OF JULY 2"      "SUMMARY OF JULY 3"     
## [37] "SUMMARY OF JULY 11"     "SUMMARY OF JULY 22"    
## [39] "SUMMARY JULY 23-24"     "SUMMARY OF JULY 26"    
## [41] "SUMMARY OF JULY 29"     "SUMMARY OF AUGUST 1"   
## [43] "SUMMARY AUGUST 2-3"     "SUMMARY AUGUST 7"      
## [45] "SUMMARY AUGUST 9"       "SUMMARY AUGUST 10"     
## [47] "SUMMARY AUGUST 17"      "SUMMARY AUGUST 21"     
## [49] "SUMMARY AUGUST 28"      "SUMMARY SEPTEMBER 4"   
## [51] "SUMMARY SEPTEMBER 20"   "SUMMARY SEPTEMBER 23"  
## [53] "SUMMARY SEPT. 25-26"    "SUMMARY: OCT. 20-21"   
## [55] "SUMMARY: OCTOBER 31"    "SUMMARY: NOV. 6-7"     
## [57] "SUMMARY: NOV. 16"       "NO SEVERE WEATHER"     
## [59] "SUMMARY OF MAY 22"      "SUMMARY OF JUNE 6"     
## [61] "SUMMARY AUGUST 4"       "SUMMARY OF JUNE 10"    
## [63] "SUMMARY OF JUNE 18"     "SUMMARY SEPTEMBER 3"   
## [65] "SUMMARY: SEPT. 18"      "NONE"                  
## [67] "SUMMARY OF MARCH 24-25" "SUMMARY OF MARCH 27"   
## [69] "SUMMARY OF MARCH 29"    "MONTHLY PRECIPITATION" 
## [71] "MONTHLY TEMPERATURE"    "NORTHERN LIGHTS"       
## [73] "DROWNING"
```

None of the summary rows contain information on FATALTIES or DAMAGE—the variables of interest—so will be removed. Other categories that did not fit in anywhere and indicated no damage or fatalities were removed.

```r
s <- sData[grepl("SUMMARY", sData$EVTYPE),]
s <- s[,2:6]
colSums(s)
```

```
## FATALITIES   INJURIES    PROPDMG PROPDMGEXP    CROPDMG 
##          0          0          0          0          0
```

```r
sData <- sData[!grepl("SUMMARY|MONTHLY PRECIPITATION|MONTHLY TEMPERATURE", ignore.case=TRUE, sData$EVTYPE),]

sData <- sData[!grepl("NO SEVERE WEATHER|NONE|DROWNING|NORTHERN LIGHTS|OTHER", ignore.case=TRUE, sData$EVTYPE),] 
```

Final check. I now have all 516 original EVTYPES reduced to the canonical 48 EVTYPES.

```r
count_unique()
```

```
## [1] 48
```

```r
list_unique(sData$EVTYPE) #should be 0 if all are matched
```

```
## The following 0 values are not in the standard 48 EVTYPES:
```

```
## character(0)
```
## Results

### Economic Effects of Storm Events
To determine which types of events (as indicated in the EVTYPE variable) are most harmful with respect to the economy, I aggregated the total damage in US Dollars by event type for property damage, crop damage and total damage. These were all combined into a new data frame. The top 10 events with the highest amount of total damage were subsetted and plotted. 


```r
prop <- aggregate(PROPDMGDOL ~ EVTYPE,sData, sum)
crop <- aggregate(CROPDMGDOL ~ EVTYPE,sData, sum)
total <- aggregate(TOTALDMGDOL ~ EVTYPE,sData, sum)


storm_econ<- join_all(list(prop, crop, total), by = "EVTYPE")
storm_econ <- storm_econ[order(-storm_econ$TOTALDMGDOL),][1:10,]
storm_econ<- melt(storm_econ, id=c("EVTYPE"), measure.vars=c("PROPDMGDOL","CROPDMGDOL"))
storm_econ$EVTYPE <- as.factor(storm_econ$EVTYPE)
 ggplot(data=storm_econ, aes(EVTYPE, value, fill =variable)) + geom_bar(stat="identity")+xlab("Storm Event") + ylab("Total Damage in US Dollars") + ggtitle("Crop and Property Damage by Storm Event")
```

![plot of chunk unnamed-chunk-40](./StormData_files/figure-html/unnamed-chunk-40.png) 

### Health Effects of Storm Events
To determine which types of events (as indicated in the EVTYPE variable) are most harmful with respect to population health, I aggregated the total amount of injuries and fatalities by event type. Then I created a new variable TOTAL that combined the total amount of injuries and fatalities. The 10 events with the highest amount of total injuries and fatalities were subsetted and plotted. 

Note that this data only counts fatalities or injuries directly related to the storm. From the Storm Data documentation:

>2.6.1 Direct Fatalities/InjuriesA direct fatality or injury is defined as a fatality or injury directly attributable to the hydro-meteorological event itself, or impact by >airborne/falling/ moving debris, i.e., missiles generated by wind, water, ice, lightning, tornado, etc. In these cases, the weather event was an “active” agent or generated debris which became an active agent.Generalized examples of direct fatalities/injuries would include: 
1. Thunderstorm wind gust causes a moving vehicle to roll over; 
2. Blizzard winds topple a tree onto a person; and 
3. Vehicle is parked on a road, adjacent to a dry arroyo. A flash flood comes down the arroyo and flips over the car. The driver drowns. 


```r
fatalities <- aggregate(FATALITIES ~ EVTYPE,sData, sum)
injuries <- aggregate(INJURIES ~ EVTYPE,sData, sum)

storm_health <- join_all(list(fatalities, injuries), by = "EVTYPE")
storm_health$TOTAL <- storm_health$FATALITIES + storm_health$INJURIES
storm_health <- storm_health[order(-storm_health$TOTAL),][1:10,]
storm_health <- melt(storm_health, id=c("EVTYPE"), measure.vars=c("FATALITIES","INJURIES"))
storm_health$EVTYPE <- as.factor(storm_health$EVTYPE)
ggplot(data=storm_health, aes(EVTYPE, value, fill =variable)) + geom_bar(stat="identity")+xlab("Storm Event") + ylab("Total") + ggtitle("Injuries and Fatalities by Storm Event")
```

![plot of chunk unnamed-chunk-41](./StormData_files/figure-html/unnamed-chunk-41.png) 

## Conclusion 
Hurricanes caused the most economic damage, with over $87 billion dollars in property and crop damage.  Tornadoes are the most dangerous having caused 1,511 fatalities and 20,667 injuries since 1996.

On the basis of this report, preventative measures aimed at reducing casualties and damage during tornadoes and hurricanes will have the greatest economic and health impacts. 

