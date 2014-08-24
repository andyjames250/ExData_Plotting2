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
# The fips column seems to have several unusual values but these are not
# relevant to the project so leave them as is for now

## Plot 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.
library(reshape2)
library(plyr)
plot1a <- melt(data = NEI[, c(6, 4)])
plot1b <- ddply(plot1a, .(year), summarize, Emissions = sum(value))
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")
barplot(height = plot1b$Emissions, names.arg = plot1b$year, main = "Total U.S. PM2.5 Emissions by Year")
dev.off()

## Plot 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a
# plot answering this question.
plot2a <- NEI[NEI$fips == "24510", c(6, 4)]
