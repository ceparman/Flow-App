
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)




options(shiny.maxRequestSize=300*1024^2)
shinyServer(function(input, output, session) {
 
   session$onSessionEnded(function() {
     unlink("ImageAppoutput",recursive = TRUE)
    stopApp()
  })
  
 
  
  output$status <- renderText({ 
    
    if (is.null(input$gfp_file)) "Select inputs" else "Hit Process" })
  
 
  # 
  observeEvent(input$run,{
    
    if (is.null( input$input_file) )
    {
    
      return()
       
    } else {
    
      
    
    #process data
    
      output$status <- renderText("Processing Data")
      
    setwd(path.expand("~"))  
      
    unlink( paste0(getwd(),"/FlowAppoutput"),recursive = T)
    
    
    suppressWarnings( main_flow_script(input$input_file$datapath,
                input$map_file$datapath,getwd())
    )
      
      zip::zip("results.zip","FlowAppoutput",recurse = TRUE)
    
      output$status <- renderText("Analysis Completed")
    }
      
      
    })
 
  
#### Download output  
  
 
    output$downloadData <- downloadHandler(
     
       filename = function() {
      
        paste0("Results-",format(Sys.time(),"%Y-%m-%d--%H:%M"),".zip")
      },
      content = function(file) {
        
        file.copy(from = "results.zip", to = file)
        
      }
      ,contentType = "application/zip"
    )
    
       
   
    
    
  })
  
  
  
  
  

    
    

