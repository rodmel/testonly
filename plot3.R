

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
                ,Sub_metering_1 = as.numeric(tmp$Sub_metering_1)
                ,Sub_metering_2 = as.numeric(tmp$Sub_metering_2)
                ,Sub_metering_3 = as.numeric(tmp$Sub_metering_3)
        ) 

        rm(tmp) ## release the memory used by "tmp" as it is no longer needed
        setkey(data, DateTime) ## create DateTime as the Key of the Data Table

## Step 2: extract data points to be plotted
##----------------------------------------------------------------------------
        points = as.data.frame( data[, list(DateTime, Sub_metering_1, 
                                        Sub_metering_2, Sub_metering_3) ])

        rm(data) ## tidy up unwanted object

## Step 3: Create the graph to png file
##----------------------------------------------------------------------------

        # open device
        png(filename="plot3.png", width=480, height=480, bg="transparent")

        # plot and annotate the graph
        plot( points$DateTime, points$Sub_metering_1, type="n"
              , bg="transparent", xlab="", ylab="Energy sub metering")

        lines(points$DateTime,points$Sub_metering_1,  col="black")
        lines(points$DateTime,points$Sub_metering_2,  col="red")
        lines(points$DateTime,points$Sub_metering_3,  col="blue")

        legend("topright", lty=1, col = c("black","red","blue"), 
               legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

        # close the device
        dev.off()

        rm(points) ## tidy up unwanted object



