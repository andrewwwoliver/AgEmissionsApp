# ui.R

# Source UI modules
source("options.R")
source("module_summary.R")
source("hc_theme.R")
library(shinyjs)

# Function to create the footer panel
create_footer <- function() {
  div(
    class = "footer",
    span("Last Updated: ", format(Sys.Date(), "%d/%m/%Y")),
    img(src = "sg.png", alt = "SG Logo", style = "height: 30px; margin-left: 10px;")
  )
}

# Function to generate the sidebar layout for each tab
generate_sidebar_layout <- function(id_prefix, chart_type) {
  sidebarLayout(
    sidebarPanel(
      id = paste0("sidebar_", id_prefix),
      width = 3,
      sliderInput(paste0("summary_current_year_", id_prefix), "Current Year", min = 1990, max = 2022, value = 2022, step = 1, sep = ""),
      sliderInput(paste0("summary_comparison_year_", id_prefix), "Comparison Year", min = 1990, max = 2022, value = 2021, step = 1, sep = "")
    ),
    mainPanel(
      id = paste0("mainpanel_", id_prefix),
      width = 9,
      tabsetPanel(
        id = paste0(id_prefix, "_tabs"),
        tabPanel("Summary Page",
                 value = paste0(id_prefix, "_summary"),
                 fluidRow(
                   column(width = 12, div(class = "header-text", "Top 3 Categories:"))
                 ),
                 fluidRow(
                   column(width = 4, valueBoxUI(paste0("totalIndustry1_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, valueBoxUI(paste0("totalIndustry2_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, valueBoxUI(paste0("totalIndustry3_", id_prefix)), style = "padding-right: 0; padding-left: 0;")
                 ),
                 fluidRow(
                   column(width = 12, div(class = "header-text", "Summary Analysis:"))
                 ),
                 fluidRow(
                   column(width = 4, valueBoxUI(paste0("totalValue_", id_prefix)), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, chartUI(paste0("industryPieChart_", id_prefix), "Industry Emissions Over Time"), style = "padding-right: 0; padding-left: 0;"),
                   column(width = 4, chartUI(paste0("industryBarChart_", id_prefix), "Emissions by Category"), style = "padding-right: 0; padding-left: 0;")
                 )
        )
      )
    )
  )
}

# Generate the UI
ui <- fluidPage(
  useShinyjs(),  # Initialize shinyjs
  theme = shinytheme("flatly"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  div(class = "container-fluid full-height",
      div(class = "content",
          navbarPage(
            title = div(
              div("Agricultural Emissions Dashboard", style = "display: inline-block; margin-right: 20px;"),
              tags$li(class = "nav-item", img(src = "RESAS Logo.png", class = "header-logo"))
            ),
            id = "navbar",
            tabPanel("Agriculture Emissions", value = "subsector", generate_sidebar_layout("subsector", "Subsector Emissions")),
            tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas", "Gas Emissions"))
          )
      ),
      create_footer()
  )
)
