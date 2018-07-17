
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel(title=div(img(src="logo-frequency-therapeutics.png"))
             ,windowTitle = "Application Name"),

  
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      tags$h4("Cell Imaging Analysis"),
      tags$hr(),
      
      textOutput("status"),
      
      tags$hr(),
      
      fileInput("gfp_file", 'Choose GFP+ Data File',        #small File
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv','application/zip')),
            
     fileInput("total_file", 'Choose Total Area Data File',        #large file
               accept=c('text/csv', 
                        'text/comma-separated-values,text/plain', 
                         '.csv','application/zip')),
                        
    fileInput("map_file", 'Choose Plate Map File',
              accept=c('text/csv', 
                       'text/comma-separated-values,text/plain', 
         
                                     '.csv','application/zip')),
    tags$hr(),
    
   # textInput("path", "Directory for Saved Data"),
    
   
    
    tags$hr(),
      actionButton("run","Process Data"),
    
     downloadButton("downloadData", "Download")
   
      
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot")
    )
  )
))
