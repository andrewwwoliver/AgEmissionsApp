library(shiny)

# UI function for the play button module
playButtonUI <- function(id) {
  ns <- NS(id)
  actionButton(ns("playPause"), "", icon = icon("play-pause"), class = "btn", style = "margin-top: 24px;")
}

# Server function for the play button module
playButtonServer <- function(id, current_year, start_year, end_year, session) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    updateYear <- function() {
      year <- current_year()
      if (year < end_year) {
        current_year(year + 1)
      } else {
        current_year(start_year)
        session$sendCustomMessage(type = 'resetPlayButton', message = NULL)
      }
    }
    
    observe({
      if (!is.null(input$playPause) && input$playPause %% 2 == 1) {
        isolate({
          updateYear()
        })
        invalidateLater(1000, session)
      }
    })
  })
}
