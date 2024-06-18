## module_area_chart.R
# UI function for the area chart module
areaChartUI <- function(id) {
  ns <- NS(id)
  highchartOutput(ns("area_chart"))
}

# Server function for the area chart module
areaChartServer <- function(id, data, group_column, title, yAxisTitle) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    reactive_colors <- reactive({
      assign_colors(data(), preset_colors)
    })
    
    output$area_chart <- renderHighchart({
      chart_data <- data()
      colors <- reactive_colors()
      
      hc <- highchart() %>%
        hc_chart(type = "area", style = list(fontFamily = "Roboto")) %>%
        hc_yAxis(title = list(text = yAxisTitle(), style = list(color = "#000000", fontSize = "20px", fontFamily = "Roboto"))) %>%
        hc_xAxis(
          labels = list(style = list(color =  "#000000", fontSize = "20px", fontFamily = "Roboto")),
          title = list(text = "", style = list(color = "#000000", fontSize = "20px", fontFamily = "Roboto")),
          type = "category"
        ) %>%
        hc_plotOptions(area = list(stacking = "normal")) %>%
        hc_legend(align = "left", alignColumns = FALSE, layout = "horizontal") %>%
        hc_tooltip(pointFormat = "{point.y:,.1f}") %>%
        hc_plotOptions(area = list(colorByPoint = FALSE)) %>%
        hc_add_theme(thm)
      
      unique_groups <- unique(chart_data[[group_column()]])
      for (g in unique_groups) {
        hc <- hc %>%
          hc_add_series(
            name = g,
            data = chart_data[chart_data[[group_column()]] == g, ] %>% select(x = Year, y = Value),
            color = colors[[g]]
          )
      }
      
      hc
    })
  })
}
