processReaderFile <-function(inFile,plate)  # processes one plate
{
  
  mydata <- read.csv(inFile, header=TRUE, skip=17, sep=",")
  
  
  #Remove all rows where column 4 in not True
  
  filtered <-  mydata %>% filter(Total == "True"  )
  
  sumColumnNumber <- 11
  sumColumnName <- names(mydata)[sumColumnNumber]
  
  filtered$area<- as.numeric(filtered[,sumColumnNumber])
  
  
  totalArea <- filtered  %>% group_by(Well) %>% summarise(total = sum(area))
  
  colnames(totalArea) <- c("Well","Total Area")
  
  
  totalCounts <- as.data.frame(table(filtered$Well),stringsAsFactors = FALSE)
  colnames(totalCounts) <- c("Well","Total Count")  
  
  allData <- merge(totalCounts,totalArea, by= "Well",all = TRUE) 
  
  allData <- merge( allData,plate,by="Well",all.y = TRUE)  
  
  allData <- allData[order(allData$index),]
  
  allData  
  
  
  
}

