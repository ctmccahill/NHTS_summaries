
modeCodes <- function(m){
  if(m=="AUTO"){
    codes<-c(1,2,3,4)
  }else if(m=="TRANSIT"){
    codes<-c(9,10,13,14,15,16,17,18)
  }else if(m=="WALK"){
    codes<-c(23)
  }else if(m=="BIKE"){
    codes<-c(22)
  }else{
    codes<-c(1:4,9:10,13:18,22,23)
  }
  return(codes)
}

modeCodes2009 <- function(m){
  if(m=="AUTO"){
    codes<-c(1,2,3,4)
  }else if(m=="TRANSIT"){
    codes<-c(9,10,13,14,15,16,17,18)
  }else if(m=="WALK"){
    codes<-c(23)
  }else if(m=="BIKE"){
    codes<-c(22)
  }else{
    codes<-c(1:4,9:10,13:18,22,23)
  }
  return(codes)
}
