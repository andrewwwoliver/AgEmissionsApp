#module_summary.R

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(highcharter)

# Function to create a small line plot for the value boxes
small_line_plot <- function(data, color) {
  ggplot(data, aes(x = Year, y = Value)) +
    geom_line(color = color) +
    theme_void() +
    theme(plot.background = element_rect(fill = "transparent", color = NA))
}

# Function to create an arrow for Year on Year change
create_yoy_arrow <- function(change) {
  if (is.na(change) || is.nan(change)) {
    icon("minus", style = "color: grey;")
  } else if (change > 0) {
    icon("arrow-up", style = "color: green;")
  } else {
    icon("arrow-down", style = "color: red;")
  }
}

# UI Module for Value Box
valueBoxUI <- function(id) {
  ns <- NS(id)
  uiOutput(ns("valueBox"))
}

# Server Module for Value Box
valueBoxServer <- function(id, data, category, industry, current_year, comparison_year) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    reactive_data <- reactive({ data() %>% filter(!!sym(category()) == !!industry(), Year %in% c(current_year(), comparison_year())) })
    
    output$valueBox <- renderUI({
      data_filtered <- reactive_data()
      current_value <- data_filtered %>% filter(Year == current_year()) %>% summarise(Value = sum(Value, na.rm = TRUE)) %>% pull(Value)
      comparison_value <- data_filtered %>% filter(Year == comparison_year()) %>% summarise(Value = sum(Value, na.rm = TRUE)) %>% pull(Value)
      yoy_change <- if (comparison_value == 0 || is.na(comparison_value)) NA else ((current_value - comparison_value) / comparison_value) * 100
      
      box(
        class = "value-box",
        title = NULL,
        width = 12,
        solidHeader = TRUE,
        div(
          style = "display: flex; flex-direction: column; justify-content: space-between; height: 100%;",
          div(
            style = "flex: 1;",
            h5(class = "value-box-title", industry()),
            div(
              style = "display: flex; align-items: center;",
              h3(sprintf("%.2f", current_value)),
              span("MtCO2e", class = "value-box-units")
            ),
            div(style = "display: flex; align-items: center;",
                create_yoy_arrow(yoy_change),
                span(class = "value-box-yoy", ifelse(is.na(yoy_change), "NA", sprintf("%.2f%%", yoy_change)), style = ifelse(yoy_change > 0, "color: green; margin-left: 5px;", "color: red; margin-left: 5px;"))
            )
          ),
          div(plotOutput(ns("sparkline"), height = "30px", width = "100%"))
        )
      )
    })
    
    output$sparkline <- renderPlot({ small_line_plot(data() %>% filter(!!sym(category()) == !!industry()), "#28a745") })
  })
}

# UI Module for Chart
chartUI <- function(id, title) {
  ns <- NS(id)
  box(
    title = span(class = "box-title", title),
    width = 12,
    solidHeader = TRUE,
    div(class = "box-content", highchartOutput(ns("chartOutput"), height = "300px"))
  )
}

# Server Module for Pie Chart
summaryPieChartServer <- function(id, data, current_year, category) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$chartOutput <- renderHighchart({
      pie_data <- data() %>% filter(Year == current_year() & !!sym(category()) != "Total") %>% group_by(!!sym(category())) %>% summarise(Value = sum(Value, na.rm = TRUE))
      highchart() %>%
        hc_chart(type = "pie") %>%
        hc_series(list(data = list_parse(pie_data %>% transmute(name = !!sym(category()), y = Value)))) %>%
        hc_plotOptions(pie = list(dataLabels = list(enabled = FALSE), tooltip = list(pointFormat = '<b>{point.name}</b>: {point.y:.2f} MtCO2e ({point.percentage:.2f} %)')))
    })
  })
}

# Server Module for Bar Chart
summaryBarChartServer <- function(id, data, current_year, comparison_year, category) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    output$chartOutput <- renderHighchart({
      bar_data <- data() %>% filter(Year == current_year() & !!sym(category()) != "Total") %>% group_by(!!sym(category())) %>% summarise(Value = sum(Value, na.rm = TRUE))
      line_data <- data() %>% filter(Year == comparison_year() & !!sym(category()) != "Total") %>% group_by(!!sym(category())) %>% summarise(Value = sum(Value, na.rm = TRUE))
      
      highchart() %>%
        hc_chart(type = "bar") %>%
        hc_xAxis(categories = bar_data[[category()]]) %>%
        hc_yAxis(title = list(text = "MtCO2e")) %>%
        hc_add_series(name = as.character(current_year()), data = bar_data$Value, type = "bar", color = "#2f7ed8") %>%
        hc_add_series(name = as.character(comparison_year()), data = line_data$Value, type = "scatter", color = "#ff0000", marker = list(enabled = TRUE, symbol = "line", lineWidth = 2, radius = 3)) %>%
        hc_plotOptions(series = list(groupPadding = 0, pointPadding = 0.1, borderWidth = 0)) %>%
        hc_tooltip(shared = TRUE, pointFormat = '{series.name}: <b>{point.y:.2f} MtCO2e</b><br/>')
    })
  })
}
