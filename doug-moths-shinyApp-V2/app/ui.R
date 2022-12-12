ui <- fluidPage(
    tags$head(tags$style(".rightAlign{float:right;}")),
    titlePanel("Plotting Field Sightings"),
    fileInput(
        inputId = 'file1', 'Select the sightings .csv file',
        accept=c('text/csv','text/comma-separated-values,text/plain','.csv')
        ),
    leafletOutput("map",height = 700,width=1500)
    # tableOutput("contents")
)