# UI function for the area chart module
areaChartUI <- function(id) {
  ns <- NS(id)
  highchartOutput(ns("area_chart"))
}

# Server function for the area chart module
areaChartServer <- function(id, data, group_column, title, yAxisTitle) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$area_chart <- renderHighchart({
      hchart(data(), "area", hcaes(x = Year, y = Value, group = .data[[group_column()]]), style = list(fontFamily = "Roboto")) %>%
        hc_yAxis(title = list(text = yAxisTitle(), style = list(color = "#000000", fontSize = "20px", fontFamily = "Roboto"))) %>%
        hc_xAxis(
          labels = list(style = list(color =  "#000000", fontSize = "20px", fontFamily = "Roboto")),
          title = list(text = "", style = list(color = "#000000", fontSize = "20px", fontFamily = "Roboto")),
          type = "category"
        ) %>%
        hc_plotOptions(area = list(stacking = "normal")) %>%
        hc_legend(align = "left", alignColumns = FALSE, layout = "horizontal") %>%
        hc_tooltip(pointFormat = "{point.y:,.1f}") %>%
        hc_add_theme(thm)
    })
  })
}
