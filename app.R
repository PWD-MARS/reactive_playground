library(shiny)

# The question that led to this app was about when to use () when accessing 
# reactive() objects vs reactiveValues(). The app has four input text boxes, 
# and four boxes that shows a combined string of the three inputs. The output combos:

# 1. r is just a df stored as a reactive object
# 2. rVal is based on the output of a df stored in a reactiveValues object.
# 3. rvr is r being stored inside of rVal

# Define UI
ui <- fluidPage(
  textInput("val1", "Val 1"),
  textInput("val2", "Val 2"),
  textInput("val3", "Val 3"),
  actionButton("print", "print"),
  actionButton("clear_all", "Clear All"),
  verbatimTextOutput("r"),
  verbatimTextOutput("rVal"),
  verbatimTextOutput("rValr"),
  verbatimTextOutput("aval")
)

# Define server logic 
server <- function(input, output) {
  vals <- reactive(tibble::tibble(
    val1 = input$val1,
    val2 = input$val2,
    val3 = input$val3
  ))
    # dplyr::glimpse(vals()[1,1])
    output$r <- renderText(paste(vals()$val1, " ", vals()$val2, " ", vals()$val3))
    
    rv <- reactiveValues()
    
    observe({
      rv$df <- tibble::tibble(
      val1 = input$val1,
      val2 = input$val2,
      val3 = input$val3
      
    )
    })

    output$rVal <- renderText(paste(rv$df$val1, " ", rv$df$val2, " ", rv$df$val3))
    
    rvr <- reactiveValues()
    
    rvr$r <- reactive(
      tibble::tibble(
        val1 = input$val1,
        val2 = input$val2,
        val3 = input$val3
      )
    )
    
    output$rValr <- renderText(paste(rvr$r()$val1, " ", rvr$r()$val2, " ", rvr$r()$val3))
    
    observeEvent(input$clear_all, {
      updateTextInput(inputId = "val1", value =  "")
      updateTextInput(inputId ="val2", value =  "")
      updateTextInput(inputId = "val3", value = "")
    })
    
    observeEvent(input$print, {
      output$aval <- renderPrint(rvr$r)
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
