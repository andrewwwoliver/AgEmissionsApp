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


# Highchart options
hcoptslang <- getOption("highcharter.lang")
hcoptslang$thousandsSep <- ","
hcoptslang$numericSymbols <- " "
options(highcharter.lang = hcoptslang)

# Load the theme
thm <- source("hc_theme.R")$value

# Load the .RData file containing the datasets
load("ghg_data.RData")