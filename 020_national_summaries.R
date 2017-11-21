
library(plyr)

#### Analysis --------

## Check totals  ----
sum(day$WTTRDFIN, na.rm=T) # Person trips
 # 2001 should equal 384,485 million (407262485207)
 # 2009 should equal 392,023 million (392022844961)
temp <- day[day$TRPMILES>=0,]
sum(temp$TRPMILES*temp$WTTRDFIN, na.rm=T) # Person miles
 # 2001 should equal 3,783,979 million (3.972749e+12)
 # 2009 should equal 3,732,791 million (3.732791e+12)
temp <- day[day$TRPTRANS %in% modeCodes("AUTO"),] # 2009 - 324052257979
temp <- day[day$VMT_MILE>=0,] # 2009 - 230982422633
temp <- day[day$DRVR_FLG==1,] # 2009 - 233912560345
sum(temp$WTTRDFIN, na.rm=T) # Vehicle trips
 # 2001 should equal 233,030 million (233036695764)
 # 2009 should equal 233,849 million
remove(temp)

## Specify geographic units ----
day$COUNTRY <- "United States"
hh$COUNTRY <- "United States"
per$COUNTRY <- "United States"
geogs <- c("COUNTRY","HHSTATE","HHC_MSA")
geog <- "HHSTATE"

for(geog in geogs){
  ## Trip summaries ----
  data1 <- merge(day, per, all.x=T)
  data1$TRPMILES <- ifelse(data1$TRPMILES>=0,data1$TRPMILES,0)
  data1$TRVL_MIN <- ifelse(data1$TRVL_MIN>=0,data1$TRVL_MIN,0)
  data1$tripCount <- 1
  
  # By purpose and mode.
  tripsPurpMode <- ddply(
    data1,
    c("TRIPPURP","TRPTRANS",geog),
    summarize,
    trips=sum(tripCount),
    tripsWt=sum(WTTRDFIN),
    miles=sum(TRPMILES),
    milesWt=sum(TRPMILES*WTTRDFIN),
    mins=sum(TRVL_MIN),
    minsWt=sum(TRVL_MIN*WTTRDFIN),
    tripCount=sum(tripCount)
  )
  files2 <- list.files(path=sprintf("NHTS %s/",as.character(year)))
  modeCodes <- read.csv(sprintf("NHTS %s/%s", as.character(year), files2[grep("TRPTRANS",files2)]))
  tripsPurpMode <- merge(tripsPurpMode, modeCodes)
  tripsPurpMode$TRPTRANS_FREQ <- NULL
  
  # By age.
  data1$ageClass <- ifelse(data1$R_AGE>=0 & data1$R_AGE<=15, "0 to 15",
                           ifelse(data1$R_AGE>=16 & data1$R_AGE<=17, "16 to 17",
                                  ifelse(data1$R_AGE>=18 & data1$R_AGE<=24, "18 to 24",
                                         ifelse(data1$R_AGE>=25 & data1$R_AGE<=34, "25 to 34",
                                                ifelse(data1$R_AGE>=35 & data1$R_AGE<=44, "35 to 44",
                                                       ifelse(data1$R_AGE>=45 & data1$R_AGE<=54, "45 to 54",
                                                              ifelse(data1$R_AGE>=55 & data1$R_AGE<=64, "55 to 64",
                                                                     "65 and older"
                                                              )))))))
  tripsAge <- ddply(
    data1,
    c("ageClass",geog),
    summarize,
    trips=sum(tripCount),
    tripsWt=sum(WTTRDFIN),
    miles=sum(TRPMILES),
    milesWt=sum(TRPMILES*WTTRDFIN),
    mins=sum(TRVL_MIN),
    minsWt=sum(TRVL_MIN*WTTRDFIN),
    tripCount=sum(tripCount)
  )
  
  remove(data1)
  
  #### Household VMT --------
  if(!"VMT_MILE" %in% names(day)){
    day$VMT_MILE <- ifelse(day$DRVR_FLG==1 & day$TRPMILES>0, day$TRPMILES, 0)
  }
  data2 <- day[day$VMT_MILE>=0,]
  data3 <- ddply(
    data2,
    c("HOUSEID",geogs),
    summarize,
    vmtHh = sum(VMT_MILE),
    vmtHhWt = sum(VMT_MILE*WTTRDFIN)
  )
  sum(data3$vmtHhWt, na.rm=T) # Total VMT
  # 2001 should equal 2,274,769 million (2.274771e+12)
  # 2009 should equal 2,245,111 million (2.245111e+12)
  data3 <- merge(data3, hh[,c("HOUSEID","WTHHFIN")])
  data3$hhCount <- 1
  vmt <- ddply(
    data3,
    c(geog),
    summarize,
    vmtHh = mean(vmtHh),
    #vmtHhWt = weighted.mean(vmtHh, WTHHFIN),
    hhCount = sum(hhCount)
  )
  remove(data2,data3)
  
  #### Write data --------
  write.csv(tripsPurpMode,sprintf("Output/NHTS%s_%s_tripsPurpMode.csv",year,geog), row.names=F)
  write.csv(tripsAge,sprintf("Output/NHTS%s_%s_tripsAge.csv",year,geog), row.names=F)
  write.csv(vmt,sprintf("Output/NHTS%s_%s_vmt.csv",year,geog), row.names=F)
}





