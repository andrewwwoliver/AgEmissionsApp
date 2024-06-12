# line_chart_module.R

# UI function for the line chart module
lineChartUI <- function(id) {
  ns <- NS(id)
  tagList(
    highchartOutput(ns("line_chart")),
    h2("Note:"),
    p("To remove a series from the chart, either deselect from the sidebar menu or click on its legend."),
    p("You can see data values for a specific year by hovering your mouse over the line.")
  )
}

thm <- source("hc_theme.R")$value


# Server function for the line chart module
lineChartServer <- function(id, data, group_column, title, yAxisTitle) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    output$line_chart <- renderHighchart({
      hchart(data(), "line", hcaes(x = Year, y = Value, group = .data[[group_column()]]), style = list(fontFamily = "Roboto")) %>%   
        hc_yAxis(title = list(text = yAxisTitle(), style = list(color = "#000000", fontSize = "20px", fontFamily = "Roboto"))) %>%
        hc_xAxis(
          labels = list(style = list(color =  "#000000", fontSize = "20px", fontFamily = "Roboto")),
          title = list(text = "", style = list(color = "#000000", fontSize = "20px", fontFamily = "Roboto")),
          type = "category"
        ) %>% 
        hc_legend(align = "left", alignColumns = FALSE, layout = "horizontal") %>% 
        hc_tooltip(pointFormat = "{point.y:,.1f}") %>% 
        hc_add_theme(thm)
    })
  })
}


