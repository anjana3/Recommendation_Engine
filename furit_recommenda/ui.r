#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
 
library(shiny)
library(DT)
# Define UI for application that draws a histogram
Apple_data <- as.data.frame(readr::read_csv("/mnt/Input/Apple Dataset for presentation.csv"))
Apple_data = Apple_data[c(1:206),c(1:9)]
a = setNames(as.list(c(Apple_data[,1])), c(Apple_data[,1]))
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Apple Recommendation Engine"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("Apple_type", label = h3("Select Apple"), 
                  choices = a, 
                  selected = Apple_data[128,1]),
      hr(),
      h4("Select preference from 1-8"),
      fluidRow(
        column(6,sliderInput("Availability", "Availability:",
                  min = 1, max = 8,
                  value = 5),
      sliderInput("Size", "Size:",
                  min = 1, max = 8,
                  value = 6)),
      column(6,sliderInput("Skin", "Skin:",
                            min = 1, max = 8,
                            value = 7),
             sliderInput("Flesh", "Flesh:",
                         min = 1, max = 8,
                         value = 2)),
      column(6,sliderInput("Flavor", "Flavor:",
                           min = 1, max = 8,
                           value = 8),
             sliderInput("CO", "CO:",
                         min = 1, max = 8,
                         value = 1)),
      column(6,sliderInput("Vitamins", "Vitamins:",
                           min = 1, max = 8,
                           value = 4),
             sliderInput("Elements", "Elements:",
                         min = 1, max = 8,
                         value = 3))
      ),
      actionButton("At", "Search")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      h3("Searched Apple"),
      DT::dataTableOutput("Searched_Apple"),
      h3("Recommended Apples"),
      DT::dataTableOutput("Recommended_Apple")
    )
  )
))
