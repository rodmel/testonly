
## rm(list=ls()); source("test.R")
## 

## Step 1: use the data.table function "fread" to quickly read the large file
##         and filter only those required data (Dates within Feb.1-2, 2007). 
##----------------------------------------------------------------------------

        library(data.table)
        
        # save to "tmp" the subset data
        tmp <- fread("household_power_consumption.txt", sep=";"
                     , header=TRUE, colClasses="character"
                     , na.strings=c("?","NA")
        )[Date=="1/2/2007" | Date=="2/2/2007"]
        
        # create the data by correctly formatting the "tmp" subset data
        # Note: Date and Time are combined as one variable DateTime 
        data <- data.table( 
                DateTime=as.POSIXct(strptime( paste(tmp$Date,tmp$Time)
                                              , format="%d/%m/%Y %H:%M:%S"))
                ,Global_active_power = as.numeric(tmp$Global_active_power)
                ,Global_reactive_power = as.numeric(tmp$Global_reactive_power)
                ,Voltage = as.numeric(tmp$Voltage)
                ,Global_intenstity = as.numeric(tmp$Global_intensity)
                ,Sub_metering_1 = as.numeric(tmp$Sub_metering_1)
                ,Sub_metering_2 = as.numeric(tmp$Sub_metering_2)
                ,Sub_metering_3 = as.numeric(tmp$Sub_metering_3)
        ) 
        
        rm(tmp) ## release the memory used by "tmp" as it is no longer needed
        setkey(data, DateTime) ## create DateTime as the Key of the Data Table

## Step 2: extract data points to be plotted
##----------------------------------------------------------------------------
        pts = as.data.frame(data)
        rm(data) ## tidy up unwanted object


## Step 3: Create the graph to png file
##----------------------------------------------------------------------------

        # open device
        png(filename="plot4.png", width=480, height=480, bg="transparent")

        par(mfrow = c(2,2)) ## set 2 rows of 2 columns of graphs row-wise

        ### Graph 1 ### ------------------------------------------------------
        plot( pts$DateTime, pts$Global_active_power, type="n"
              ,xlab="", ylab="Global Active Power")
        lines(pts$DateTime, pts$Global_active_power, col="black")

        ### Graph 2 ### ------------------------------------------------------
        plot( pts$DateTime, pts$Voltage, type="n"
              ,xlab="datetime", ylab="Voltage")
        lines(pts$DateTime, pts$Voltage, col="black")

        ### Graph 3 ### ------------------------------------------------------
        plot( pts$DateTime, pts$Sub_metering_1, type="n"
              , bg="transparent", xlab="", ylab="Energy sub metering")
        
        lines(pts$DateTime, pts$Sub_metering_1,  col="black")
        lines(pts$DateTime, pts$Sub_metering_2,  col="red")
        lines(pts$DateTime, pts$Sub_metering_3,  col="blue")
        
        legend("topright", lty=1, col = c("black","red","blue"), 
               legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

        ### Graph 4 ### ------------------------------------------------------
        plot( pts$DateTime, pts$Global_reactive_power, type="n"
              ,xlab="datetime", ylab="Voltage")
        lines(pts$DateTime, pts$Global_reactive_power, col="black")

        ###------------------------------------------------------
        dev.off() # close the device
        rm(pts)   # tidy up unwanted object

