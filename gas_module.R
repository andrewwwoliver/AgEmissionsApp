#gas_module.R

library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(highcharter)

# Data setup for Gas Emissions
full_data_gas <- reactive({ agri_gas })

# UI for Gas Emissions Module
gasUI <- function(id) {
  ns <- NS(id)
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput(ns("summary_current_year_gas"), "Current Year", min = 1990, max = 2022, value = 2022, step = 1, sep = ""),
        sliderInput(ns("summary_comparison_year_gas"), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1, sep = "")
      ),
      mainPanel(
        tabsetPanel(
          id = ns("gas_tabs"),
          tabPanel("Summary Page",
                   fluidRow(
                     column(width = 12, div(class = "header-text", "Top 3 Categories:"))
                   ),
                   fluidRow(
                     column(width = 4, valueBoxUI(ns("totalIndustry1_gas")), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, valueBoxUI(ns("totalIndustry2_gas")), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, valueBoxUI(ns("totalIndustry3_gas")), style = "padding-right: 0; padding-left: 0;")
                   ),
                   fluidRow(
                     column(width = 12, div(class = "header-text", "Summary Analysis:"))
                   ),
                   fluidRow(
                     column(width = 4, valueBoxUI(ns("totalValue_gas")), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, chartUI(ns("industryPieChart_gas"), "Industry Emissions Over Time"), style = "padding-right: 0; padding-left: 0;"),
                     column(width = 4, chartUI(ns("industryBarChart_gas"), "Emissions by Category"), style = "padding-right: 0; padding-left: 0;")
                   )
          )
        )
      )
    )
  )
}

# Server for Gas Emissions Module
gasServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    current_year <- reactive({ input$summary_current_year_gas })
    comparison_year <- reactive({ input$summary_comparison_year_gas })
    
    first_col_name <- "Gas"
    
    valueBoxServer("totalIndustry1_gas", full_data_gas, first_col_name, get_industry(1, full_data_gas, current_year, first_col_name), current_year, comparison_year)
    valueBoxServer("totalIndustry2_gas", full_data_gas, first_col_name, get_industry(2, full_data_gas, current_year, first_col_name), current_year, comparison_year)
    valueBoxServer("totalIndustry3_gas", full_data_gas, first_col_name, get_industry(3, full_data_gas, current_year, first_col_name), current_year, comparison_year)
    valueBoxServer("totalValue_gas", full_data_gas, first_col_name, reactive("Total"), current_year, comparison_year)
    summaryPieChartServer("industryPieChart_gas", full_data_gas, current_year, first_col_name)
    summaryBarChartServer("industryBarChart_gas", full_data_gas, current_year, comparison_year, first_col_name)
  })
}
