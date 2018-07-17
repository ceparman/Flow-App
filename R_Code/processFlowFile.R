processFlowFile <-function(inFile,plate)  # processes one plate
{
  
  mydata <-  read.csv2(inFile,sep=",", as.is = TRUE,fill = TRUE)

  
   
  filtered <- mydata %>% filter( (Gate == "Cells" &  Y.Parameter == "FSC-W") |  Gate == "Viability-PI-/Lgr5-GFP+") %>%
              mutate( Well = Sample)  %>% select(Gate,Well,Count,X.Gated,Sample)
  
  
  
  total_cells <- filtered %>% filter(Gate == "Cells") %>% mutate(allcells_area= Count) %>% select(Well,allcells_area) 
  
  gfp_cells <- filtered %>%  filter(Gate == "Viability-PI-/Lgr5-GFP+") %>% mutate(gfp_area= Count, percent = as.numeric(X.Gated)) %>% select(Well,gfp_area,percent) 
  
  
  
  
  
  
  allData <- merge(total_cells,gfp_cells, by= "Well",all = TRUE) 
  
  
  allData <- merge( allData,plate,by="Well",all.y = TRUE)  
  
  allData <- allData[order(allData$index),]
  
  allData  
  
  
  
}

