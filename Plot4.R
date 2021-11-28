## This script loads and cleans the data, before creating plot 4.

## Load packages
library(tidyverse)
library(lubridate)


## Read data

  # Download file
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
                "household_power_consumption.zip")
  
  # Unzip file
  unzip("household_power_consumption.zip")

  # read into dataframe
  HPC <- as.data.frame(
          read.delim("household_power_consumption.txt",
                       header = TRUE, 
                       sep = ';'
                     )
  )
  # To avoid having to read again if need to start over
  HPC_backup <- HPC

## Clean data
  
  ## Clean date & time
  # Combine into one POSIXct variable
  HPC <- 
    HPC %>%
      mutate(Date_Time = dmy_hms(paste(Date, Time)))
  
  # Move it to the front
  HPC <- relocate(HPC, Date_Time, .before = "Date")
  
  # Remove Date and Time variables
  HPC <- select(HPC, -"Date", -"Time")
  
  # Filter on dates of interest to reduce dataset size
  # 1st Feb 2007 (Thursday) to 3rd Feb 2007 (Saturday)
  HPC <- filter(HPC, Date_Time >= dmy(01022007) & Date_Time <= dmy(03022007))
  
    # Check there are now only three dates
    unique(date(HPC$Date_Time))
    
  ## Convert character variables to numeric
  HPC[2:8] <- sapply(HPC[2:8], as.numeric)
  
  
  
  

    
## Create plot
  # Reset if not reset already
  plot.new()
  
  ## Set up png
  png(filename = "plot4.png")
  
  # Check device
  dev.cur()
  
  # Set parameters
  # Sets up as 2x2 grid for charts
  par(mfrow = c(2,2))
  
  
  
  ## Construct first plot
  with(HPC, 
       plot(Date_Time,
            Global_active_power,
            type = "l",
            ylab = "Global Active Power (kilowatts)",
            xlab = NA
       )
  )
  
  
  ## Construct second plot
  with(HPC, 
       plot(Date_Time,
            Voltage,
            type = "l",
            xlab = "datetime"
       )
  )
  
  
  
  
  ## Construct third plot
    # Create the first line
    with(HPC, 
         plot(Date_Time,
              Sub_metering_1,
              type = "l",
              ylab = "Energy sub metering",
              xlab = NA
              )
    )
    
    # Add the second line
    with(HPC, 
         lines(Date_Time,
               Sub_metering_2,
               type = "l",
               col = "red"
              )
    )
    
    # Add the third line
    with(HPC, 
         lines(Date_Time,
               Sub_metering_3,
               type = "l",
               col = "blue"
         )
    )
    
    # Add a legend to the plot
    legend("topright", 
           legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
           col=c("black", "red", "blue"),
           lty = 1,
           cex = 0.8
           )   

  
  ## Construct fourth plot
  with(HPC, 
       plot(Date_Time,
            Global_reactive_power,
            type = "l",
            xlab = "datetime"
       )
  )
  
  
  # Close dev
  dev.off()
  
  # Check device
  dev.cur()
  
  
  
  
  
  
  
  
  
  
  