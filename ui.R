# ui.R

# Source UI modules
source("panels.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")
source("module_summary.R")
source("hc_theme.R")

# Function to create the footer panel
create_footer <- function() {
  div(
    class = "footer",
    span("Last Updated: ", Sys.Date()),
    img(src = "sg.png", alt = "SG Logo", style = "height: 30px; margin-left: 10px;")
  )
}

# Generate the UI
ui <- fluidPage(
  theme = shinytheme("flatly"),  # Apply a shiny theme
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  div(class = "container-fluid full-height",  # Ensure the full height of the container
      div(class = "content",
          navbarPage(
            title = div(
              div("Agricultural Emissions Dashboard", style = "flex-grow: 1;"),
              img(src = "RESAS Logo.png", class = "header-logo")  # Add logo here
            ),
            id = "navbar",
            tabPanel("Agriculture Emissions", value = "subsector", generate_layout("subsector", "Subsector Emissions")),
            tabPanel("Industry Emissions", value = "total", generate_layout("total", "Total Emissions")),
            tabPanel("Gas Emissions", value = "gas", generate_layout("gas", "Gas Emissions"))
          )
      ),
      create_footer()  # Add the footer panel
  )
)
