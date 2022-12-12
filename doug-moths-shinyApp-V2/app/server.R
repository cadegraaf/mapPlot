server <- function(input,output, session){

data <- eventReactive(input$file1, {
    fileTable = read.csv(input$file1$datapath)
    #remove white space in the data file
    fileTable$latitude = as.numeric(str_trim(fileTable$latitude))
    fileTable$longitude = as.numeric(str_trim(fileTable$longitude))
    fileTable
  
})


 output$map <- renderLeaflet({
   df <- data()
   
  pal <- colorFactor(
  palette = c('#e76f51','#023047','#606c38'), # one color per species
  domain = levels(as.factor(df$species))
  )

   m <- leaflet(data = df) %>%
   addProviderTiles(providers$CartoDB.Positron)%>%
    # addMarkers(
    #     lng = ~longitude, 
    #     lat = ~latitude,
    #     popup = paste("Species:", df$species)
    #     )
    addCircles(
        radius = 100,
        weight =10,
        color = ~pal(species),
        popup = paste("Species:", df$species)
        )%>%
    addLegend(
        pal = pal, 
        values = ~species,
        title = "Species",
        opacity = 2
    )    
   m
 })
 
output$contents <- renderTable({
        df <- data()
        df
    })
    
}