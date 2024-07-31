#subsector_module.R

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(highcharter)

# Data setup for Subsector Emissions
full_data_subsector <- reactive({ subsector_total })

# UI for Subsector Emissions Module
subsectorUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput(ns("summary_current_year_subsector"), "Current Year", min = 1990, max = 2022, value = 2022, step = 1, sep = ""),
        sliderInput(ns("summary_comparison_year_subsector"), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1, sep = "")
      ),
      mainPanel(
        tabsetPanel(
          id = ns("subsector_tabs"),
          tabPanel("Summary Page",
                   fluidRow(
                     column(width = 12, div(class = "header-text", "Top 3 Categories:"))
                   ),
                   fluidRow(
                     column(width = 4, valueBoxUI(ns("totalIndustry1_subsector")), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, valueBoxUI(ns("totalIndustry2_subsector")), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, valueBoxUI(ns("totalIndustry3_subsector")), style = "padding-right: 0; padding-left: 0;")
                   ),
                   fluidRow(
                     column(width = 12, div(class = "header-text", "Summary Analysis:"))
                   ),
                   fluidRow(
                     column(width = 4, valueBoxUI(ns("totalValue_subsector")), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, chartUI(ns("industryPieChart_subsector"), "Industry Emissions Over Time"), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, chartUI(ns("industryBarChart_subsector"), "Emissions by Category"), style = "padding-right: 0; padding-left: 0;")
                   )
          )
        )
      )
    )
  )
}

# Server for Subsector Emissions Module
subsectorServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    current_year <- reactive({ input$summary_current_year_subsector })
    comparison_year <- reactive({ input$summary_comparison_year_subsector })
    
    first_col_name <- "Subsector"
    
    valueBoxServer("totalIndustry1_subsector", full_data_subsector, first_col_name, get_industry(1, full_data_subsector, current_year, first_col_name), current_year, comparison_year)
    valueBoxServer("totalIndustry2_subsector", full_data_subsector, first_col_name, get_industry(2, full_data_subsector, current_year, first_col_name), current_year, comparison_year)
    valueBoxServer("totalIndustry3_subsector", full_data_subsector, first_col_name, get_industry(3, full_data_subsector, current_year, first_col_name), current_year, comparison_year)
    valueBoxServer("totalValue_subsector", full_data_subsector, first_col_name, reactive("Total"), current_year, comparison_year)
    summaryPieChartServer("industryPieChart_subsector", full_data_subsector, current_year, first_col_name)
    summaryBarChartServer("industryBarChart_subsector", full_data_subsector, current_year, comparison_year, first_col_name)
  })
}
