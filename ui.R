##ui.R

# Source UI modules
source("module_sidebar.R")
source("module_line_chart.R")
source("module_data_table.R")
source("options.R")
source("module_area_chart.R")
source("module_bar_chart.R")

# Custom CSS to adjust the layout
custom_css <- "
.full-width {
  width: 100% !important;
}
.full-height {
  height: 100vh !important;
}
.sidebar {
  width: 250px;
  padding: 10px;
  border-right: 1px solid #ddd;
  float: left;  /* Float to the left */
  height: calc(100vh - 70px);  /* Adjust for header and margin */
  margin-top: 10px !important;  /* 10px gap from header */
}
.main-panel {
  margin-left: 270px;
  padding: 10px;
  overflow: auto;  /* Enable scrolling for main content */
  height: calc(100vh - 70px);  /* Adjust for header and margin */
  margin-top: 10px !important;  /* 10px gap from header */
}
.header-logo {
  position: absolute;
  top: 0px;
  right: 0px;
  height: 60px;
}
"


# Generate the UI
ui <- fluidPage(
  theme = shinytheme("flatly"),  # Apply a shiny theme
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),  # Link to your custom CSS
    tags$style(HTML(custom_css))  ),
  div(class = "container-fluid full-height",  # Ensure the full height of the container
      navbarPage(
        title = div(
          div("Agricultural Emissions Dashboard", style = "flex-grow: 1;"),
          img(src = "RESAS Logo.png", class = "header-logo")  # Add logo here
        ),
        id = "navbar",
        tabPanel("Agriculture Emissions", value = "subsector", generate_sidebar_layout("subsector")),
        tabPanel("Industry Emissions", value = "total", generate_sidebar_layout("total")),
        tabPanel("Gas Emissions", value = "gas", generate_sidebar_layout("gas"))
      )
  )
)
