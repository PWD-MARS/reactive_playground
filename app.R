library(shiny)

# The question that led to this app was about when to use () when accessing 
# reactive() objects vs reactiveValues(). The app has four input text boxes, 
# and four boxes that shows a combined string of the three inputs. The output combos:

# 1. r is just a tibble stored as a reactive object
# 2. rVal is based on the output of a tibble stored in a reactiveValues object.
# 3. rValr is r being stored inside of rVal

# Define UI
ui <- fluidPage(
  titlePanel("Using reactive vs reactiveValues"),
  tags$body(
    p("The goal of this app is to show how using", code("reactive"), "and", code("reactiveValues"), "can differ\n
      The app combines the values of three text inputs using:")),
      tags$ol(
        tags$li(code("reactive()")),
        tags$li(code("reactiveValues()")),
        tags$li(code("reactiveValues(df = reactive())"))
        ),
  p("We can see the text entered for each val are reactive as they update each as changes are made. The print code button shows what happens when we try and print the values of the objects
    The code for this app can be found", a(href="https://github.com/jonbry/reactive_playground/blob/main/app.R", "here")),
  # Text Inputs
  textInput("val1", "Val 1"),
  textInput("val2", "Val 2"),
  textInput("val3", "Val 3"),
  # Print the actual objects
  actionButton("print", "Print Objects"),
  # Clear text inputs
  actionButton("clear_all", "Clear All"),
  # Actual reactivey objects 
  htmlOutput("printr"),
  verbatimTextOutput("r"),
  htmlOutput("printrVal"),
  verbatimTextOutput("rVal"),
  htmlOutput("printrValr"),
  verbatimTextOutput("rValr")
  )

# Define server logic 
server <- function(input, output) {
  # Save tibble of inputs into a reactive object
  vals <- reactive(tibble::tibble(
    val1 = input$val1,
    val2 = input$val2,
    val3 = input$val3
  ))
    # Output the concatenated text
    output$r <- renderText(paste(vals()$val1, " ", vals()$val2, " ", vals()$val3))
    
    # Save tibble of inputs into reactiveValues object
    rv <- reactiveValues()
    # Watch for inputs into a tibble
    observe({
      rv$df <- tibble::tibble(
      val1 = input$val1,
      val2 = input$val2,
      val3 = input$val3
      
    )
    })
    
    # Output the reactive value object
    output$rVal <- renderText(paste(rv$df$val1, " ", rv$df$val2, " ", rv$df$val3))
    
    # reactiveValues object to save the the reactive object r into
    rvr <- reactiveValues()
    # Save reactive object r into reactiveValues object rvr
    rvr$r <- reactive(
      tibble::tibble(
        val1 = input$val1,
        val2 = input$val2,
        val3 = input$val3
      )
    )
    # Print the values within rvr
    output$rValr <- renderText(paste(rvr$r()$val1, " ", rvr$r()$val2, " ", rvr$r()$val3))
    
    # Clear inputs
    observeEvent(input$clear_all, {
      updateTextInput(inputId = "val1", value =  "")
      updateTextInput(inputId ="val2", value =  "")
      updateTextInput(inputId = "val3", value = "")
    })
    # Print out values
    observeEvent(input$print, {
      output$printr <- renderText("<b>reactive Object (vals())</b>")
      output$printrVal <- renderText("<b>reactiveValues object (rv)</b>")
      output$printrValr <- renderText("<b>reactive object in a reactiveValues object (rvr$r)</b>")
      output$r <- renderPrint(vals())
      output$rval <- renderPrint(rv)
      output$rValr <- renderPrint(rvr$r)
    })
}
# Run the application 
shinyApp(ui = ui, server = server)
