


## Step 1: use the data.table function "fread" to quickly read the large file
#          and filter only those required data (Dates within Feb.1-2, 2007). 
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
                ) 
        
        rm(tmp) ## release the memory used by "tmp" as it is no longer needed
        setkey(data, DateTime) ## create DateTime as the Key of the Data Table

## Step 2: extract data points to be plotted
##----------------------------------------------------------------------------
        xpoints <- as.data.frame(data[, list(Global_active_power)])[,1]
        rm(data) ## tidy up unwanted object

## Step 3: Create the graph to png file
##----------------------------------------------------------------------------

        # open device
        png(filename="plot1.png", width=480, height=480, bg="transparent")
        
        # plot the graph
        hist(xpoints, col="red", xlab="Global Active Power (kilowatts)"
             , ylab="Frequency", main="Global Active Power")
        
        dev.off() # close the device
        
        rm(xpoints) ## tidy up unwanted object




