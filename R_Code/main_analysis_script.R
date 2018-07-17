
main_flow_script <- function(inFile,plate_map_file,filePath)
  
{

### create directory if it does not exist
  

filePath <- paste0(filePath,"/FlowAppoutput")  
  
  if(!dir.exists(filePath)) dir.create(filePath)   
  
  
plate <- makePlate()

plate_map <- parse_plate_map2(plate_map_file )

all_data <- processFlowFile(inFile,plate)


### Write output

m<- merge(plate_map,all_data,by=c("Well","index"))

m <- m[order(m$index),]

mnames<-colnames(m)

mnames[9] <- "allcells_count"
mnames[10] <- "gfp_count"

mt<- m

colnames(mt) <- mnames

write.csv(mt,file=paste0(filePath,"/All_data.csv"),row.names = FALSE)

#calculate mean and STD of replicates

averaged <- m %>% filter(!is.na(var_compound)) %>%
       group_by(var_compound,concentration) %>%
  summarise(mean_gfp_area = mean(gfp_area,na.rm = TRUE), std_gfp_area = sd(gfp_area,na.rm = TRUE),
            mean_all_area =mean(allcells_area,na.rm = TRUE), std_all_area =sd(allcells_area,na.rm = TRUE),
            mean_percent = mean(percent,na.rm = TRUE)  , std_percent = sd(percent,na.rm = TRUE)
            ) 


content <-  plate_map %>% filter(!is.na(var_compound)) %>% select(content, var_compound, control, concentration, units) %>% unique


s<- left_join(averaged,content,by=c("var_compound","concentration"))

s<- s[order(s$var_compound,s$concentration),]

snames <- colnames(s)
snames <- str_replace(snames,"_area","_count")

st <- s

colnames(st) <- snames
write.csv(st,file=paste0(filePath,"/summary_data.csv"),row.names = FALSE)


processed_data <- list(summary=s,well=m)

make_plots(processed_data,filePath)





}




