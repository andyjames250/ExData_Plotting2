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
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
library(reshape2)
library(plyr)
library(ggplot2)
# Extract rows with type "ON-ROAD" from NEI data frame and melt
plot5a <- melt(NEI[NEI$fips == "24510" & NEI$type == "ON-ROAD", c(2, 6, 4)])
# Create emissions totals by SCC and year
plot5b <- ddply(plot5a, .(SCC, year), summarize, Emissions = sum(value))
# Merge with SCC descriptive data
plot5c <- merge(x = plot5b, y = SCC[, c(1, 7, 8, 9, 10)], by.x = "SCC", by.y = "SCC", all.x = TRUE, all.y = FALSE)
g <- ggplot(plot5c, aes(year, Emissions))
png(filename = "plot5.png", width = 480, height = 960, bg = "transparent")
g + geom_bar(stat = "identity") + facet_wrap(~ SCC.Level.Three, ncol = 1) + labs(x = NULL) + labs(y = "Tons") + labs(title = "Baltimore City, MD Motor Vehicle-Related PM2.5 Emissions by Year")
dev.off()