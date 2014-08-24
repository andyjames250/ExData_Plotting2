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

## Plot 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.
library(reshape2)
library(plyr)
plot2a <- melt(NEI[NEI$fips == "24510", c(6, 4)])
plot2b <- ddply(plot2a, .(year), summarize, Emissions = sum(value))
png(filename = "plot2.png", width = 480, height = 480, bg = "transparent")
barplot(height = plot2b$Emissions[1:4], names.arg = plot1b$year[1:4], main = "Baltimore City, MD PM2.5 Emissions by Year", ylab = "Tons")
dev.off()