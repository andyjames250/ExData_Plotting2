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

## Plot 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad,
# nonroad) variable, which of these four sources have seen decreases in
# emissions from 1999–2008 for Baltimore City? Which have seen increases in
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot
# answer this question.
library(reshape2)
library(plyr)
library(ggplot2)
plot3a <- melt(NEI[NEI$fips == "24510", c(5, 6, 4)])
plot3b <- ddply(plot3a, .(type, year), summarize, Emissions = sum(value))
g <- ggplot(plot3b[1:16, ], aes(year, Emissions))
png(filename = "plot3.png", width = 480, height = 480, bg = "transparent")
g + geom_bar(stat = "identity") + facet_wrap(~ type) + labs(x = "") + labs(y = "Tons") + labs(title = "Baltimore City, MD PM2.5 Emissions by Type and Year")
dev.off()