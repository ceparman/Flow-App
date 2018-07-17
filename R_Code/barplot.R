
bar_plot<-function(scaled,compound,ratio)
{
plot_data <- scaled%>% ungroup()

plot_data <- plot_data %>% mutate( maxy = pmax( (mean_all_area + std_all_area), (mean_gfp_area + std_gfp_area),
                                                mean_all_area, mean_gfp_area , na.rm = TRUE))


plot_data <- plot_data %>% filter(var_compound == compound |!is.na(control))  




#stack the data

gfp_data <- plot_data %>% select(mean_gfp_area, std_gfp_area,concentration,units,control,mean_percent,maxy ) %>% 
  mutate(target = "Total GFP+ Area")%>% mutate ( mean = mean_gfp_area, std = std_gfp_area ) %>% 
  select(-mean_gfp_area, -std_gfp_area)

all_data <- plot_data %>% select(mean_all_area, std_all_area,concentration,units,control, mean_percent,maxy ) %>% 
  mutate(target = "Total Cell Area")%>% mutate ( mean = mean_all_area, std = std_all_area ) %>% 
  select(-mean_all_area, -std_all_area)




bar_data <- bind_rows(gfp_data,all_data)

bar_data <-  bar_data %>% mutate( x_label = ifelse( is.na(units), concentration, paste(concentration,units) ))

suppressWarnings(
  bar_data <-  bar_data %>% mutate(plotorder = ifelse(is.na(control), (as.numeric(concentration,rm.na=TRUE)*10000 +10), as.numeric(control,rm.na=TRUE))) 
)






title <- paste0(plot_data$var_compound[ is.na(plot_data$control) ][1], " CRC with ",
                stringr::str_split(plot_data$content[ is.na(plot_data$control) ][1],":")[[1]][1] )


#need to remove ever other mean_percent  

bar_data <- bar_data %>% mutate( mean_percent = ifelse ( target == "Total GFP+ Area",
                                                         paste(as.character(round(mean_percent,1)),"%"),
                                                         ""))

bar_data$target <- str_replace(bar_data$target,"Area", "Count")


options(scipen=10000)



bp<- ggplot(bar_data ,aes(fill= factor(target, levels=c("Total GFP+ Count", "Total Cell Count")),y=mean,x=reorder(x_label,plotorder))) +
  
  
  geom_errorbar(aes(ymin=mean-std,ymax=mean+std),  width=0.25,position = position_dodge(.9)) +
  
  geom_bar(position="dodge", stat="identity" )+
  
  scale_fill_manual(values=rep(c("green","red"),nrow(bar_data)/2))+
  
  scale_y_continuous(sec.axis = sec_axis(~.*(1/ratio),name = "Total Cell Count")) +
  labs(y= "Total GFP(+) Cell Count", x="") +
  
  ggtitle(title) +
  
  geom_text(
    aes(label = mean_percent, y = maxy*1.05),
    position = position_dodge(.1),
    vjust = 0
  ) +
  
  
  theme_classic()+
  
  theme(axis.text.x = element_text(angle = 90, hjust = 1), legend.position = "top",legend.title=element_blank()) +
  theme(axis.title.y = element_text(colour = "green"), axis.title.y.right = element_text(color = "red")) +
  theme(axis.title.y.right = element_text(angle = 270)) 

bp


}
