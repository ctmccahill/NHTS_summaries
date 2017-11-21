
library(utils) # download.file()

nhtsUrl2001 <- "http://nhts.ornl.gov/2001/download/Ascii.zip"
nhtsUrl2009 <- "http://nhts.ornl.gov/2009/download/Ascii.zip"

## Download data ----
tempFile <- tempfile()
if(year==2001){
  download.file(nhtsUrl2001, tempFile)
}else if(year==2009){
  download.file(nhtsUrl2009, tempFile)
}

## Unzip data ----
tempDir <- tempdir()
nhtsZip <- unzip(tempFile, exdir = tempDir)

## Get file names and identify relevant files ----
dayFile <- which(grepl("DAY",nhtsZip)*grepl("CSV",nhtsZip)==1)
vehFile <- which(grepl("VEH",nhtsZip)*grepl("CSV",nhtsZip)==1)
hhFile <- which(grepl("HH",nhtsZip)*grepl("CSV",nhtsZip)==1)

## Read data ----
day <- read.csv(nhtsZip[dayFile])
veh <- read.csv(nhtsZip[grep("VEH",nhtsZip)])
hh <- read.csv(nhtsZip[grep("HH",nhtsZip)])

## Remove temporary files ----
remove(nhtsUrl2001, nhtsUrl2009, tempFile, tempDir, nhtsZip, dayFile, vehFile, hhFile)


