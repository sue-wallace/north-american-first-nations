#Sue Wallace
#18.05.2018

#Creating a map of masssacres that occured in Canada and the United States between 1500
#and the end of the 1600s. 
#This map is created using the leaflet package and some very basic HTML

#I got the inspiration to make this map when reading 'The Inconvenient Indian', a book by Thomas King

#The data are collected by myself and will be updated over time to be more substantive. For that
#reason this map currently isn't an extensive list of massacres that occured within the time period.

#useful resources----

#https://rstudio.github.io/leaflet/

#shiny.rstudio.com

#load libraries----
library(leaflet)
#library(dplyr)
library(htmltools)
library(shiny)
library(shinythemes)
library(readxl)

d <-read_xlsx("Data/massacres.xlsx")

#create the UI
ui <- {fluidPage(theme = shinytheme("slate"), titlePanel("Massacres in 
                                                         North America involving 
                                                         First Nations Peoples: 1500-1700"), 
                 sidebarLayout(position = "right",
                               sidebarPanel(
                                 selectInput(inputId = "input1", label = "Tribe name" ,choices = 
                                               unique(d$Tribe_name))
                                 
                               ),
                               
                               mainPanel(
                                 leafletOutput("mymap")
                               )
                 )
)}


server <- function(input, output) {
  
  
  react <- reactive({
    req(input$input1)
    df <- d[d$Tribe_name == input$input1,]
    df
  }) 
  
  #This code  can be used to change the icon from a circle marker to a green leaf one.
  
  #greenLeafIcon <- makeIcon(
   # iconUrl = "http://leafletjs.com/examples/custom-icons/leaf-green.png",
    #iconWidth = 38, iconHeight = 95,
    #iconAnchorX = 22, iconAnchorY = 94,
   # shadowUrl = "http://leafletjs.com/examples/custom-icons/leaf-shadow.png",
   # shadowWidth = 50, shadowHeight = 64,
   # shadowAnchorX = 4, shadowAnchorY = 62
  #)
  
  output$mymap <- renderLeaflet({ req(input$input1)
    
    leaflet(data = react()) %>% addTiles() %>% setView(lng = -100.94, lat = 38.94 , zoom = 3.5) %>% 
      addProviderTiles(providers$Esri.NatGeoWorldMap) %>%
      addCircleMarkers(lng = react()$longitude, lat= react()$latitude, #icon=greenLeafIcon, 
                 popup = paste(react()$massacre_name, "<br>", "Date:",
                               react()$date,
                               "<br>", "Number of native casualties:",
                               react()$native_casualties,
                               "<b><a href"= react()$web)
      ) 
  })
}

shinyApp(ui, server)