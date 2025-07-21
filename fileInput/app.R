# Test to see if we can get the file name from a shiny app
# The issue is that fileInput() saves the file to a temporary foler on the shiny server
# ie. "...02 GSI Monitoring Sites\Weinberg Street Locations_1090\SRT\1090-3\20241025\QAQC_Liner Test_1090-3_20241025_BN.xlsx"
# becomes "C:\\Users\\JONATH~1.BRY\\AppData\\Local\\Temp\\RtmpY5XXSY/64a7cf9d956b4d06301eecaf/0.xlsx"
# We want to get the name of the QAQC file for the Liner app so we can go back and grab it later if we want.

library(shiny)
# The default size of shiny arguments is 5mb (v1.10)
options(shiny.maxRequestSize = 10 * 1024^2)

# UI
ui <- fluidPage(

    # Application title
    titlePanel("Testing file input"),
    # File input
    fileInput("shiny",
              "Shiny File Input"),
    # Show uploaded file data
    tableOutput("file_data")

)

# Server
server <- function(input, output) {
  # Capture name when file is uploaded
  observeEvent(input$shiny, {
    file_name <- input$shiny$name
    dplyr::glimpse(file_name)
    output$file_data <- renderTable(input$shiny) 
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
