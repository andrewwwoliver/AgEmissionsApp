# module_line_chart.R

# UI function for the line chart module
lineChartUI <- function(id) {
  ns <- NS(id)
  tagList(
    htmlOutput(ns("title")),  # Use htmlOutput instead of textOutput
    highchartOutput(ns("line_chart")),
    h2("Note:"),
    p("To remove a series from the chart, either deselect from the sidebar menu or click on its legend."),
    p("You can see data values for a specific year by hovering your mouse over the line.")
  )
}

# Server function for the line chart module
lineChartServer <- function(id, data, group_column, title, yAxisTitle) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    reactive_colors <- reactive({ assign_colors(data(), preset_colors) })
    
    # Title of the plot
    output$title <- renderUI({
      year_min <- min(data()$Year)
      year_max <- max(data()$Year)
      HTML(paste0("<div style='font-size: 20px; font-weight: bold;'>", title(), " ", year_min, " to ", year_max, "</div>"))
    })
    
    output$line_chart <- renderHighchart({
      chart_data <- data()
      colors <- reactive_colors()
      hc <- highchart() %>%
        hc_chart(type = "line", zoom = "xy") %>%
        hc_yAxis(title = list(text = yAxisTitle())) %>%
        hc_xAxis(type = "category", tickInterval = 5) %>%
        hc_legend(align = "left", alignColumns = FALSE, layout = "horizontal") %>%
        hc_plotOptions(line = list(colorByPoint = FALSE)) %>%
        hc_add_theme(thm)
      
      unique_groups <- unique(chart_data[[group_column()]])
      lapply(unique_groups, function(g) {
        hc <<- hc %>%
          hc_add_series(name = g, data = chart_data[chart_data[[group_column()]] == g, ] %>% select(x = Year, y = Value), color = colors[[g]])
      })
      
      hc
    })
  })
}
