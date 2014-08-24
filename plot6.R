## Download and unzip data
download.file(url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", destfile = "data.zip", method = "curl")
unzip("data.zip")

## Read data into objects
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Summarize each data frame
# summary(NEI)
# summary(SCC)

## Clean NEI data
# Convert categorical data to factors
NEI$fips <- factor(NEI$fips)
NEI$SCC <- factor(NEI$SCC)
NEI$Pollutant <- factor(NEI$Pollutant)
NEI$type <- factor(NEI$type)
NEI$year <- factor(NEI$year)
# Note: fips column seems to have several unusual values but this is not
# relevant to the project so leave them as is for now

## Plot 5
# Compare emissions from motor vehicle sources in Baltimore City with emissions
# from motor vehicle sources in Los Angeles County, California (fips ==
# "06037"). Which city has seen greater changes over time in motor vehicle
# emissions?
library(reshape2)
library(plyr)
library(ggplot2)
# Extract rows with type "ON-ROAD" from NEI data frame and melt
plot6a <- NEI[(NEI$fips == "24510" | NEI$fips == "06037") & NEI$type == "ON-ROAD", c(1, 6, 4)]
plot6a$County <- factor(plot6a$fips, labels = c("Los Angeles County, CA", "Baltimore City, MD"))
plot6b <- melt(plot6a[, c(4, 2, 3)])
# Create emissions totals by County and year
plot6c <- ddply(plot6b, .(County, year), summarize, Emissions = sum(value))
plot6c <- arrange(plot6c, year)
g <- ggplot(plot6c, aes(year, Emissions, fill = County))
png(filename = "plot6.png", width = 480, height = 480, bg = "transparent")
g + geom_bar(stat = "identity", position = "dodge") + labs(x = NULL) + labs(y = "Tons") + labs(title = "Comparison of Motor Vehicle-Related \n PM2.5 Emissions by Year")
dev.off()