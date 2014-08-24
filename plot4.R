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

## Plot 4
# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
library(reshape2)
library(plyr)
library(ggplot2)
# Create a list of SCCs where the short name indicates combustion or burning of
# coal
SCC1 <- SCC[grepl("Comb|Burn", SCC$Short.Name, ignore.case = FALSE) & 
                    grepl("Coal", SCC$Short.Name, ignore.case = FALSE),]
# Extract rows with matching SCC from NEI data frame and melt
plot4a <- melt(NEI[NEI$SCC %in% SCC1$SCC, c(2, 6, 4)])
# Create emissions totals by SCC and year
plot4b <- ddply(plot4a, .(SCC, year), summarize, Emissions = sum(value))
# Merge with SCC descriptive data
plot4c <- merge(x = plot4b, y = SCC1[, c(1, 7, 8, 9, 10)], by.x = "SCC", by.y = "SCC", all.x = TRUE, all.y = FALSE)
plot4c$log10Emissions <- log10(plot4c$Emissions)
g <- ggplot(plot4c, aes(year, log10Emissions))
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")
g + geom_bar(stat = "identity") + facet_wrap(~ SCC.Level.Two, ncol = 2) + labs(x = NULL) + labs(y = "Tons (log 10 scale)") + labs(title = "Total U.S. Coal Combustion-Related PM2.5 Emissions by Year")
dev.off()