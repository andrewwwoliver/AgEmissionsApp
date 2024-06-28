# module_area_chart.R

# UI function for the area chart module
areaChartUI <- function(id) {
  ns <- NS(id)
  tagList(
    htmlOutput(ns("title")),
    highchartOutput(ns("area_chart")),
    htmlOutput(ns("footer"))  # Add footer output
  )
}

# Server function for the area chart module
areaChartServer <- function(id, data, group_column, title, yAxisTitle, footer) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    reactive_colors <- reactive({ assign_colors(data(), preset_colors) })
    
    output$title <- renderUI({
      year_min <- min(data()$Year, na.rm = TRUE)
      year_max <- max(data()$Year, na.rm = TRUE)
      HTML(paste0("<div style='font-size: 20px; font-weight: bold;'>Agricultural Emissions by Subsector in Scotland, ", year_min, " to ", year_max, "</div>"))
    })
    
    output$footer <- renderUI({
      HTML(footer())
    })
    
    output$area_chart <- renderHighchart({
      chart_data <- data()
      colors <- reactive_colors()
      hc <- highchart() %>%
        hc_chart(type = "area", zoomType = "xy") %>%
        hc_yAxis(title = list(text = yAxisTitle())) %>%
        hc_xAxis(type = "category", tickInterval = 5) %>%
        hc_plotOptions(area = list(stacking = "normal")) %>%
        hc_legend(align = "left", alignColumns = FALSE, layout = "horizontal") %>%
        hc_plotOptions(area = list(
          stickyTracking = TRUE)) %>%
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
