##options.R

library(shiny)
library(highcharter)
library(tidyverse)
library(shinyWidgets)
library(shinythemes)
library(rsconnect)
library(png)
library(htmltools)
library(DT)
library(shinyjs)
library(RColorBrewer)
library(shinyjs)


# Highchart options
hcoptslang <- getOption("highcharter.lang")
hcoptslang$thousandsSep <- ","
hcoptslang$numericSymbols <- " "
options(highcharter.lang = hcoptslang)

# Load the theme
thm <- source("hc_theme.R")$value

# Load the .RData file containing the datasets
load("ghg_data.RData")


# Generate Titles

generate_title <- function(chart_type, data) {
  year_min <- min(data$Year, na.rm = TRUE)
  year_max <- max(data$Year, na.rm = TRUE)
  
  title <- switch(chart_type,
                  "Subsector Emissions" = paste("Agricultural Emissions by Subsector in Scotland,", year_min, "to", year_max),
                  "Total Emissions" = paste("National Emissions by Source in Scotland,", year_min, "to", year_max),
                  "Gas Emissions" = paste("Agricultural Gas Emissions Breakdown in Scotland,", year_min, "to", year_max),
                  paste("Unknown Chart Type")
  )
  
  return(title)
}