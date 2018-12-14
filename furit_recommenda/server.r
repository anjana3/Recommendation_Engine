library(shiny)
library(DT)
 
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$Searched_Apple <- DT::renderDataTable({
    req(input$At)
    Searched_Apple <- input$Apple_type
    Availability<-input$Availability
    Size<-input$Size
    Skin<-input$Skin
    Flesh<-input$Flesh
    Flavor<-input$Flavor
    CO<-input$CO
    Vitamins<-input$Vitamins
    Elements<-input$Elements
    Apple_data <- as.data.frame(readr::read_csv("/mnt/Input/Apple Dataset for presentation.csv"))
    Apple_data = Apple_data[c(1:206),c(1:9)]
    Apple_data[Apple_data[,1] == Searched_Apple,]
  })
  
  output$Recommended_Apple <- DT::renderDataTable({
    req(input$At)
    Searched_Apple <- input$Apple_type
    Availability<-input$Availability
    Size<-input$Size
    Skin<-input$Skin
    Flesh<-input$Flesh
    Flavor<-input$Flavor
    CO<-input$CO
    Vitamins<-input$Vitamins
    Elements<-input$Elements
    Apple_data <- as.data.frame(readr::read_csv("/mnt/Input/Apple Dataset for presentation.csv"))
    Apple_data = Apple_data[c(1:206),c(1:9)]
    df_apple <- as.data.frame(readr::read_csv("/mnt/Input/Apple Dataset for Recommendation Engine.csv"))
    Availability = as.numeric(Availability)
    Size = as.numeric(Size)
    Skin = as.numeric(Skin)
    Flesh = as.numeric(Flesh)
    Flavor = as.numeric(Flavor)
    CO = as.numeric(CO)
    Vitamins = as.numeric(Vitamins)
    Elements = as.numeric(Elements)
    df_apple[,c(2:5)] = df_apple[,c(2:5)]*Availability
    df_apple[,c(6:8)] = df_apple[,c(6:8)]*Size
    df_apple[,c(9:19)] = df_apple[,c(9:19)]*Skin
    df_apple[,c(20:45)] = df_apple[,c(20:45)]*Flesh
    df_apple[,c(46:65)] = df_apple[,c(46:65)]*Flavor
    df_apple[,c(66:67)] = df_apple[,c(66:67)]*CO
    df_apple[,c(68:74)] = df_apple[,c(68:74)]*Vitamins
    df_apple[,c(75:95)] = df_apple[,c(75:95)]*Elements
    d = dist(df_apple[,(-1)], method = 'euclidean', diag = TRUE, upper = TRUE)
    d = as.matrix(d)
    Searched_Apple_index = which(df_apple[,1] == Searched_Apple)
    recommended_apple_index = which(d[,Searched_Apple_index] == sort(d[,Searched_Apple_index])[2])
    Apple_data[recommended_apple_index,]
  })
  
  output$value <- renderPrint({ input$Vitamins })
  
})
