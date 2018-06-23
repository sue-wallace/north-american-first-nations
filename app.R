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

library(readxl)
library(leaflet)
library(dplyr)
library(htmltools)
library(shiny)
library(shinythemes)

#read in data----

d <-read_xlsx("Data/massacres.xlsx")


#creating a map with one massare----

leaflet() %>%
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=-82.7, lat=27.6, popup="Napituca Massacre")

#add all massacres in data----


#use the massacre data file to add all masscres in the data set to the map
#using some basic html you can add some text and breaks to the pop up to make it a bit neater

leaflet(data = d[1:25,]) %>% addTiles() %>%
  addProviderTiles(providers$Esri.NatGeoWorldMap) %>%  
  addMarkers(lng=~longitude, lat=~latitude,
             popup = ~paste(massacre_name, "<br>", "Date:", date, 
                            "<br>", "Number of native casualties:", 
                            native_casualties,"<a href=",d$web,">",d$web) 
  )


#adding the map to shiny----


#create the UI

ui <- {fluidPage(theme = shinytheme("slate"), titlePanel("Massacres in North America involving 
                                                         First Nations Peoples: 1500-1700"), 
                 sidebarLayout(position = "right",
                               sidebarPanel(
                                 selectInput(inputId = "input1", label = "Tribe name" ,choices = 
                                               unique(d$Tribe_name))
                                 
                               ),
                               
                               mainPanel(
                                 leafletOutput("mymap"))
                 )
)}


server <- function(input, output) {
  react <- reactive({
    req(input$input1)
    df <- d[d$Tribe_name == input$input1,]
    df
  })
  output$mymap <- renderLeaflet({ req(input$input1)
    
    leaflet(data = react()) %>% addTiles() %>% setView(lng = -100.94, lat = 38.94 , zoom = 3.5) %>% 
      addProviderTiles(providers$Esri.NatGeoWorldMap) %>% 
      addMarkers(lng = ~longitude, lat= ~latitude, 
                 popup = paste(react()$massacre_name, "<br>", "Date:", react()$date, 
                               "<br>", "Number of native casualties:", react()$native_casualties,
                               "<b><a href"= react()$web))
    
  })
}


shinyApp(ui, server)


