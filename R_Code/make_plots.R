##bar plot

make_plots <- function(processed_data,file_path)
  
{


  
summary_data <- processed_data$summary

well_data <- processed_data$well  
  
  
  
#Calculate scaling factors

max_gfp <- max(summary_data$mean_gfp_area + summary_data$std_gfp_area,na.rm = TRUE)
max_cell <-  max(summary_data$mean_all_area + summary_data$std_all_area,na.rm = TRUE)

ratio <- max_gfp/max_cell

#normalize all cells to GFP max

scaled <- summary_data %>% mutate( mean_all_area = mean_all_area * ratio)

scaled <- scaled %>%  mutate( std_all_area = std_all_area * ratio)
  


### loop across all var_compounds



## figure out how many variable compounds we have

compound_list <-  unique(scaled$var_compound[is.na(scaled$control)])

if( length(compound_list) > 0) {
  

for (i in 1:length(compound_list))
{
  
#make a directory for the data
  
dir_name <- compound_list[i]


dir.create(file.path(file_path,dir_name ), showWarnings = TRUE)
  
######Make bar plot ######################

bp <- bar_plot(scaled,compound_list[i],ratio)

plot.save(bp, width = 600, height = 600, text.factor = .5,filename = paste0(file.path(file_path,dir_name),"/bar_plot.png"))

############# now create percent plot




pp <- percent_plot(well_data,compound_list[i])

plot.save(pp, width = 600, height = 600, text.factor = .7,filename = paste0(file.path(file_path,dir_name),"/percent_plot.png"))



} #end compound loop
} else{  # only controls
  
  pp <- percent_plot(well_data,"")
  dir.create(file.path(file_path,"controls"), showWarnings = TRUE)
  
  plot.save(pp, width = 600, height = 600, text.factor = .7,filename = paste0(file.path(file_path,"controls"),"/percent_plot.png"))
  
}


} 
  




