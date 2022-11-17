#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


#want it to display oz on the screen no points to start with
#then upload the csv and refresh to show them

#libraries needed

#shiny
library(shiny)
library(shinyWidgets)

#plotting
library(ggplot2)

#mapping libraries
library(sf) #required for maps
library("rnaturalearth")
library("rnaturalearthdata")


#setting up maps
#currently just for oz
#will want to generalise later for everywhere
world <- ne_countries(scale = "medium", returnclass = "sf")
class(world)
australia <- subset(world, admin == "Australia")


australia <- subset(world, admin == "Australia")
(mainland <- ggplot(data = australia) +
    geom_sf(fill = "cornsilk") )


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Plotting Field Sightings"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          
          
          fileInput(inputId = 'file1', 'Select the sightings .csv file',
                    accept=c('text/csv','text/comma-separated-values,text/plain','.csv')),
          
          
  
          tags$hr(),
          checkboxInput("header", "Header", TRUE),
      
          
          
          
          numericRangeInput(
            inputId = "lat", label = "Latitude:",
            value = c(110, 160)
          ),
          numericRangeInput(
            inputId = "long", label = "Longitude:",
            value = c(-8, -50)
          )
          
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("mothPlot"),
           tableOutput("contents")
         
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
     
   
    
   
    
    output$mothPlot <- renderPlot({
      inFile <- input$file1
      if (is.null(inFile)){
        
        ggplot(data = australia) +
          geom_sf() +
          coord_sf(xlim = c(input$lat[1], input$lat[2]), ylim = c(input$long[1], input$long[2]), expand = FALSE)
      }else{
        fileTable = read.csv(inFile$datapath,header=T)
        
        ggplot(data = australia) +
          geom_sf() +
          coord_sf(xlim = c(input$lat[1], input$lat[2]), ylim = c(input$long[1], input$long[2]), expand = FALSE)+
          geom_point(data = fileTable, aes(x = longitude, y = latitude,fill=species), size = 2, 
                     shape = 23)
        
        
      }
        }
  )
      
      output$contents <- renderTable({
        # input$file1 will be NULL initially. After the user selects
        # and uploads a file, it will be a data frame with 'name',
        # 'size', 'type', and 'datapath' columns. The 'datapath'
        # column will contain the local filenames where the data can
        # be found.
        inFile <- input$file1
        if (is.null(inFile))
          return(NULL) 
        else{
          print("readToPrintTable")
          fileTable = read.csv(inFile$datapath,header=T)
          fileTable
        }
        
        

      })
      
 
  }

# Run the application 
shinyApp(ui = ui, server = server)
