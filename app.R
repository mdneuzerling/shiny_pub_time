library(shiny)
library(shinyTime)
library(magrittr)

ui <- fluidPage(
    
    titlePanel("When are we going to the pub?"),
    
    sidebarLayout(
        sidebarPanel(
            timeInput("from", "From:", value = strptime("12:00:00", "%T")),
            timeInput("to", "To:", value = strptime("18:00:00", "%T"))
        ),
        
        mainPanel(
            tags$br(),
            textOutput("pub_time"),
            tags$br(), 
            actionButton("refresh_button", "I don't like that time")
        )
    )
)

server <- function(input, output) {

    sample_time <- function(from, to, by) {
        seq(from = from, to = to, by = by) %>% 
            sample(1) %>% 
            strftime(format="%H:%M") %>% 
            as.character
    }  
    
    refresh_time <- function() {
        output$pub_time <- renderText({
            paste0(
                "We're going to the pub at ",
                sample_time(input$from, input$to, 60)
            )
        })
    }
    
    refresh_time() # initialise first time
    
    observeEvent(input$refresh_button, {
        refresh_time()
    })
    
}

shinyApp(ui = ui, server = server)