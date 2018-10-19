# 19 October 2018
# Brett Waugh
# The output will be a directory with the graphs, and a file with the data in it.
# UPDATES: 
#   - Added map of the world [19 September 2018]
#   - Added tower locator capability [18 October 2018]
#   - Changed permissions of directory [19 October 2018]
#   - Changed script to run in current directory [19 October 2018]
#   - Changed file name format [19 October 2018]

###  SETUP  ###
# Create directory name.
directoryName <- paste("EDGES", format(Sys.time(), "%Y%m%d_%H%M%S"), sep="_")

# Create a report name.
reportName <- paste("EDGES_Report_",format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt", sep="")

# Creates directory in your current user Documents directory. 
newDirectory <- paste(directoryName,sep="")
dir.create(file.path(newDirectory))

# Make sure readr is installed already. 
#install.packages("readr")
# Load 'readr'.
library(readr)

# Make sure 'ggplot2' is installed already.
#install.packages("ggplot2")
# Load 'ggplot2'
library(ggplot2)

# Make sure '' is installed already.
#install.packages("rworldmap")
# Load 'rworldmap'
library(rworldmap)
library(maps)

# Ask for the location of the file.
inputFile <- readline(prompt="Enter file name and extension (ex. EDGES.csv): ")

# Read the input of the file and format the columns correctly. 
inputData <- read_table2(inputFile, col_types = cols(Location_Sucess = col_logical(), Speed = col_double()), na = "null")

# Loading message.
print("Processing...This may take a minute...")

### REPORT ###
# Redirect output to new direcory.
newFile <- paste(newDirectory, reportName, sep="/")
sink(newFile)

# Create a dataframe of the dataset.
df <- data.frame(inputData)

# Creates a latitude and longitude field.
location <- paste(df$Geo_Latitude, df$Geo_Longitude)

# Header for report. 
print(paste("REPORT:   ", reportName), quote=FALSE)

print(paste("REPORTER: ", Sys.getenv("USER")), quote=FALSE)

print(paste("DATE:     ",format(Sys.time(), "%d %b %Y")), quote=FALSE)

print(paste("FROM:     ", inputFile), quote=FALSE)

cat("\n")

# Shows starting location.
print("STARTING LOCATION", quote=FALSE)
print( head(location,1), na.print ="NULL", quote=FALSE) 

cat("\n")

# Shows ending location.
print("ENDING LOCATION", quote=FALSE)
print( tail(location,1), na.print ="NULL", quote=FALSE) 

cat("\n")

# Displays start and end dates of journey.
startDate <- min(df$Timestamp)/1000
startDate_formatted <- as.Date(as.POSIXct(startDate, origin="1970-01-01"))

print("STARTING DATE", quote=FALSE)
print(startDate_formatted, na.print= "NULL", quote=FALSE)

cat("\n")

endDate <- max(df$Timestamp)/1000
endDate_formatted <-  as.Date(as.POSIXct(endDate, origin="1970-01-01"))

print("ENDING DATE", quote=FALSE)
print(endDate_formatted, na.print= "NULL", quote=FALSE)

cat("\n")

# Display the days in operation.
Days_On <- df$Timestamp/1000
Days_On <- as.Date(as.POSIXct(Days_On, origin="1970-01-01"))

print("DAYS IN OPERATION", quote=FALSE)
print(unique(Days_On), quote=FALSE)

cat("\n")

# Create a formatted timestamp and apend it to the dataframe.
Timestamp_formatted <- df$Timestamp/1000
Timestamp_formatted <- as.Date(as.POSIXct(Timestamp_formatted, origin="1970-01-01"))
df["Timestamp_formatted"] <- Timestamp_formatted

# Displays average speed by day.
print("SPEED BY DAY", quote=FALSE)
print(aggregate(df$Speed ~ df$Timestamp_formatted, df, mean), quote=FALSE)

cat("\n")

# Create a smaller data frame for information relevant to finding towers.
pow_lat_lon <- data.frame(df$Power, df$Geo_Latitude, df$Geo_Longitude)

towers <- pow_lat_lon[pow_lat_lon$df.Power > -15,]

# Creates list of possible tower locations. Duplicates exist.
tow_loc <- paste(towers$df.Geo_Latitude, towers$df.Geo_Longitude)

# Displays possible tower locations. No duplications. 
# Note, this is where the signal is strongest, towers should be near these locations pointed in these directions.
# In theory, if you are at one of these locations you should be able to follow the signal until the power is
# near zero and you will have reached the tower. 
print("TOWER LOCATIONS", quote=FALSE)

print(sort(unique(tow_loc)))

cat("\n")

# End of report message. 
print("----- END OF FILE -----", quote=FALSE)

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

