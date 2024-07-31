#ui.R

# Source UI modules
source("options.R")
source("hc_theme.R")
source("gas_module.R")
source("subsector_module.R")
source("module_summary.R")

library(shinyjs)

# Function to create the footer panel
create_footer <- function() {
  div(
    class = "footer",
    span("Last Updated: ", format(Sys.Date(), "%d/%m/%Y")),
    img(src = "sg.png", alt = "SG Logo", style = "height: 30px; margin-left: 10px;")
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
            tabPanel("Agriculture Emissions", value = "subsector", subsectorUI("subsector")),
            tabPanel("Gas Emissions", value = "gas", gasUI("gas"))
          )
      ),
      create_footer()
  )
)
