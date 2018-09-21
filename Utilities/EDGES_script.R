# 14 September 2018
# Brett Waugh
# R script will load 'readr' and 'ggplot2'. The output will be a directory with the graphs, and a file with the data in it. 

###  SETUP  ###
# Create directory name.
directoryName <- paste("EDGES", Sys.Date(), sep="_")

# Create a report name.
reportName <- paste("EDGES_Report_",Sys.Date(), ".txt", sep="")

# Creates directory in your current user Documents directory. 
outputLocation <- paste("/home", Sys.getenv("LOGNAME"), "Documents/",  sep="/")
newDirectory <- paste(outputLocation, directoryName,sep="")
dir.create(file.path(newDirectory), mode = "0777")

# Make sure readr is installed already. 
#install.packages("readr")
# Load 'readr'.
library(readr)

# Make sure 'ggplot2' is installed already.
#install.packages("ggplot2")
# Load 'ggplot2'
library(ggplot2)

# Ask for the location of the file.
inputFile <- readline(prompt="Enter path to file location (include file name): ")

# Read the input of the file and format the columns correctly. 
inputData <- read_table2(inputFile, col_types = cols(Location_Sucess = col_logical(), Speed = col_double()), na = "null")

### REPORT ###
# Redirect output to new direcory.
newFile <- paste(newDirectory, reportName, sep="/")
sink(newFile)

# Create a dataframe of the dataset.
df <- data.frame(inputData)

# Creates a latitude and longitude field.
location <- paste(df$Geo_Latitude, df$Geo_Longitude)

# Shows starting location.
print("STARTING LOCATION")
print( head(location,1), na.print ="NULL") 

# Shows ending location.
print("ENDING LOCATION")
print( tail(location,1), na.print ="NULL") 

# Displays start and end dates of journey.
startDate <- min(df$Timestamp)/1000
startDate_formatted <- as.Date(as.POSIXct(startDate, origin="1970-01-01"))

print("STARTING DATE")
print(startDate_formatted, na.print= "NULL")

endDate <- max(df$Timestamp)/1000
endDate_formatted <-  as.Date(as.POSIXct(endDate, origin="1970-01-01"))

print("ENDING DATE")
print(endDate_formatted, na.print= "NULL")

# Display the days in operation.
Days_On <- df$Timestamp/1000
Days_On <- as.Date(as.POSIXct(Days_On, origin="1970-01-01"))

print("DAYS IN OPERATION")
print(unique(Days_On), sep="\n")

# Create a formatted timestamp and apend it to the dataframe.
Timestamp_formatted <- df$Timestamp/1000
Timestamp_formatted <- as.Date(as.POSIXct(Timestamp_formatted, origin="1970-01-01"))
df["Timestamp_formatted"] <- Timestamp_formatted

# Displays average speed by day.
print("SPEED BY DAY")
print(aggregate(df$Speed ~ df$Timestamp_formatted, df, mean), sep="\n")

# End of report message. 
print("END OF FILE.")

### GRAPHS ###
# Graph relating the latitude, longitude, and speed.
jpeg(paste(newDirectory,"Acceleration_Graph.jpeg", sep="/"))
Acceleration_Graph <- ggplot(df, aes(df$Geo_Latitude, df$Geo_Longitude, color=df$Speed)) + geom_point()
print(Acceleration_Graph)
dev.off()

# Graph relating latitude, longitude, and speed.
jpeg(paste(newDirectory,"Power_Graph.jpeg", sep="/"))
Power_Graph <- ggplot(df, aes(df$Frequency, df$Altitude, color=df$Power)) + geom_point()
print(Power_Graph)
dev.off()

# Graph relating latitude, longitude, and density. 
jpeg(paste(newDirectory,"Density_Graph.jpeg", sep="/"))
Density_Graph <- ggplot(df, aes(df$Geo_Latitude, df$Geo_Longitude)) + geom_bin2d()
print(Density_Graph)
dev.off()

# Graph relating speed to day.
jpeg(paste(newDirectory,"Speed_by_day.jpeg", sep="/"))
Speed_by_day <- ggplot(df, aes(df$Speed, df$Timestamp_formatted)) + geom_point()
print(Speed_by_day)
dev.off()

### END MESSAGE ###
sink()
cat("Finished.")