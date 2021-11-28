## This script loads and cleans the data, before creating plot 1.

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
  
  ## Set up png
  png(filename = "plot1.png")
  
  # Check device
  dev.cur()
  
  ## Construct plot
  with(HPC, 
       hist(Global_active_power, 
            xlab = "Global Active Power (kilowatts)",
            main = "Global Active Power",
            col = "red")
       )

  # Close dev
  dev.off()
  
  # Check device
  dev.cur()
  
  
  
  
  
  
  
  
  
  
  