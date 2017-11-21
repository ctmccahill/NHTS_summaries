
nhtsLocation <- "/Users/ctmccahill/Documents/Research/Data sets/NHTS"

## Get file names and identify relevant files ----
nhtsFiles <- list.files(path=sprintf("%s/NHTS %s/Ascii/", nhtsLocation, as.character(year)))
dayFile <- which(grepl("DAY",nhtsFiles)*grepl("CSV",nhtsFiles)==1)
vehFile <- which(grepl("VEH",nhtsFiles)*grepl("CSV",files1)==1)
hhFile <- which(grepl("HH",nhtsFiles)*grepl("CSV",nhtsFiles)==1)

## Read data ---- 
day <- read.csv(sprintf("%s/NHTS %s/Ascii/%s", nhtsLocation, as.character(year), nhtsFiles[dayFile]))
hh <- read.csv(sprintf("%s/NHTS %s/Ascii/%s", nhtsLocation, as.character(year), nhtsFiles[vehFile]))
per <- read.csv(sprintf("%s/NHTS %s/Ascii/%s", nhtsLocation, as.character(year), nhtsFiles[hhFile]))

## Remove temporary files ----
remove(nhtsLocation, nhtsFiles, dayFile, vehFile, hhFile)
