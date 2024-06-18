# UI function for the bar chart module
barChartUI <- function(id) {
  ns <- NS(id)
  tagList(
    tags$style(HTML("
      .chart-container {
        position: relative;
      }
      .chart-controls {
        position: absolute;
        top: 10px;  /* Adjusted to move up */
        right: 20px;
        display: flex;
        align-items: center;
      }
      .chart-controls .form-group {
        margin-bottom: 0;
        margin-left: 10px;
      }
      .chart-controls .btn {
        margin-left: 10px;
      }
      .year-label {
        margin-right: 10px;
        font-weight: bold;
      }
    ")),
    div(class = "chart-container",
        highchartOutput(ns("chart"), height = "500px"),  # Adjusted height here
        div(class = "chart-controls",
            div(class = "year-label", "Year:"),
            sliderInput(ns("year"), NULL, min = 2000, max = 2022, value = 2000, step = 1, animate = animationOptions(interval = 1000, loop = FALSE), width = '200px'),
            actionButton(ns("playPause"), "", icon = icon("play"), class = "btn btn-primary")
        )
    )
  )
}

# Server function for the bar chart module
barChartServer <- function(id, chart_data, chart_type, input, output) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    # Get the maximum value across all data for consistent x-axis
    max_value <- reactive({
      all_data <- chart_data()
      if (is.null(all_data) || nrow(all_data) == 0) return(0)
      max_val <- max(all_data$Value, na.rm = TRUE)
      return(max_val)
    })
    
    # Filter data based on selected year
    getData <- function(year, nbr) {
      data <- chart_data()
      if (is.null(data) || nrow(data) == 0) return(data.frame())
      data %>%
        filter(Year == year) %>%
        arrange(desc(Value)) %>%
        slice(1:nbr) %>%
        mutate(Value = as.numeric(Value))
    }
    
    # Generate subtitle
    getSubtitle <- function(year, data) {
      if (nrow(data) == 0) return("")
      total_value <- sum(data$Value, na.rm = TRUE)
      paste0("<span style='font-size: 80px'>", year, "</span><br><span style='font-size: 22px'>Total: <b>", round(total_value, 2), "</b> units</span>")
    }
    
    # Generate data list for highcharter
    getDataList <- function(data, colors) {
      if (nrow(data) == 0) return(list())
      first_col_name <- names(data)[1]
      lapply(1:nrow(data), function(i) {
        list(
          name = data[[first_col_name]][i],
          y = data$Value[i],
          color = colors[[data[[first_col_name]][i]]]
        )
      })
    }
    
    current_year <- reactiveVal(2000)
    nbr <- 20
    
    current_data <- reactive({
      getData(current_year(), nbr)
    })
    
    current_subtitle <- reactive({
      getSubtitle(current_year(), current_data())
    })
    
    current_colors <- reactive({
      assign_colors(chart_data(), preset_colors)
    })
    
    current_data_list <- reactive({
      getDataList(current_data(), current_colors())
    })
    
    updateYear <- function() {
      year <- current_year()
      if (year < 2022) {
        current_year(year + 1)
      } else {
        current_year(2000)
        session$sendCustomMessage(type = 'resetPlayButton', message = NULL)
      }
    }
    
    observe({
      if (input$playPause %% 2 == 1) {
        isolate({
          updateYear()
        })
        invalidateLater(1000, session)
      }
    })
    
    observe({
      updateSliderInput(session, "year", value = current_year())
    })
    
    output$chart <- renderHighchart({
      data <- current_data()
      if (nrow(data) == 0) return(NULL)
      first_col_name <- names(data)[1]
      highchart() %>%
        hc_chart(type = "bar", animation = list(duration = 1000)) %>%
        hc_title(text = "GHG Emissions by Industry", align = "left") %>%
        hc_subtitle(useHTML = TRUE, text = current_subtitle(), floating = TRUE, align = "right", verticalAlign = "bottom", y = 30, x = -100) %>%
        hc_xAxis(type = "category", categories = data[[first_col_name]]) %>%
        hc_yAxis(opposite = TRUE, tickPixelInterval = 150, title = list(text = NULL), max = max_value() + 1) %>%
        hc_plotOptions(series = list(
          animation = FALSE,
          groupPadding = 0,
          pointPadding = 0.1,
          borderWidth = 0,
          colorByPoint = FALSE,
          dataSorting = list(enabled = TRUE, matchByName = TRUE),
          dataLabels = list(enabled = TRUE, format = '{point.y:.2f}')
        )) %>%
        hc_series(list(
          name = as.character(current_year()),
          data = current_data_list()
        )) %>%
        hc_responsive(rules = list(
          list(
            condition = list(maxWidth = 550),
            chartOptions = list(
              xAxis = list(visible = FALSE),
              subtitle = list(x = 0),
              plotOptions = list(
                series = list(
                  dataLabels = list(
                    list(enabled = TRUE, y = 8),
                    list(enabled = TRUE, format = '{point.name}', y = -8, style = list(fontWeight = 'normal', opacity = 0.7))
                  )
                )
              )
            )
          )
        ))
    })
    
    observeEvent(input$year, {
      current_year(input$year)
    })
  })
}
